require "spec_helper"

describe Zrcon do
  before do
    ENV['RCON_HOST'] = 'joe'
    ENV['RCON_PORT'] = '666'
    ENV['RCON_PASSWORD'] = 'supersecret'
  end

  let(:rcon) { described_class.new }
  let(:not_authenticated_response) { OpenStruct.new id: -1, type: 2 }

  describe '#initialize' do
    context "when defaulting" do
      it "should use environment variables" do
        expect(subject.host).to eq 'joe'
        expect(subject.port).to eq 666
        expect(subject.password).to eq 'supersecret'
        expect(subject.id).to eq 0
      end
    end

    context "when not defaulting" do
      let(:host) { 'somehost' }
      let(:port) { 1234 }
      let(:password) { 'wifesbirthday' }

      subject { described_class.new host: host, port: port, password: password }

      it "should use params" do
        expect(subject.host).to eq host
        expect(subject.port).to eq port
        expect(subject.password).to eq password
      end
    end
  end

  describe '#conn' do
    subject { rcon.conn }

    context "when the hostname is bad" do
      before { expect(TCPSocket).to receive(:new).and_raise(SocketError) }

      it "should raise connect error" do
        expect { subject }.to raise_error(Zrcon::ConnectError, "bad hostname perhaps? (#{rcon.host})")
      end
    end

    context "when the server drops our packets" do
      before { expect(TCPSocket).to receive(:new).and_raise(Errno::ETIMEDOUT) }

      it "should raise conect error" do
        expect { subject }.to raise_error(Zrcon::ConnectError, "timed out connecting to #{rcon.host}:#{rcon.port}")
      end
    end

    context "when the connection is refused" do
      before { expect(TCPSocket).to receive(:new).and_raise(Errno::ECONNREFUSED) }

      it "should raise conect error" do
        expect { subject }.to raise_error(Zrcon::ConnectError, "connection refused")
      end
    end
  end

  def expect_send_receive
    expect(rcon).to receive(:send)
    expect(rcon).to receive(:receive).and_return(response)
  end

  describe '#auth' do
    subject { rcon.auth }

    before do
      Zrcon::Packet.class_variable_set :@@id, 0
      expect_send_receive
    end

    context 'when authentication is successful' do
      let(:password) { "supersecret" }
      let(:response) { OpenStruct.new id: 1, type: 2 }

      it { should be_truthy }
    end

    context "when authenticion is unsuccessful" do
      let(:password) { "incorrect" }
      let(:response) { not_authenticated_response }

      it { should be_falsey }
    end
  end

  describe '#command' do
    let(:command) { "list" }

    let(:encoded_request) do
      Zrcon::Packet.new(id: 1, type: 2, data: command).encode
    end

    let(:conn) { StringIO.new }

    before {
      expect(rcon).to receive(:conn).at_least(:once).and_return(conn)
      expect(conn).to receive(:write).with(encoded_request).and_return encoded_request.length

      expect(conn).to receive(:read)
        .with(4)
        .and_return([encoded_response.length-4].pack('l<'))

      expect(conn).to receive(:read).with(encoded_response.length-4).and_return(encoded_response[4..-1])
    }

    subject { rcon.command command }

    context "when the connection has not been authenticated" do
      let(:encoded_response) do
        Zrcon::Packet.new(id: -1, type: 2, data: "").encode
      end

      it { should be_nil }
    end

    context "when the connection has been authenticated" do
      let(:response) { "list response" }

      let(:encoded_response) do
        Zrcon::Packet.new(id: 1, type: 2, data: response).encode
      end

      it { should eq response }
    end
  end

  describe "auth_packet" do
    subject { rcon.auth_packet("password") }

    it "should create a packet" do
      expect(Zrcon::Packet).to receive(:new).with(id: 1, type: 3, data: "password")
      subject
    end
  end

  describe "command_packet" do
    subject { rcon.command_packet "help" }

    it "should create a packet" do
      expect(Zrcon::Packet).to receive(:new).with(id: 1, type: 2, data: "help")
      subject
    end
  end
end
