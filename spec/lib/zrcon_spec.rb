require "spec_helper"

describe Zrcon do
  def expect_send_receive
    expect(rcon).to receive(:send)
    expect(rcon).to receive(:receive).and_return(response)
  end

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
      end
    end

    context "when not defaulting" do
      let(:host) { 'somehost' }
      let(:port) { 1234 }
      let(:password) { 'wifesbirthday' }

      subject { described_class.new host, port, password }

      it "should use params" do
        expect(subject.host).to eq host
        expect(subject.port).to eq port
        expect(subject.password).to eq password
      end
    end
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
    subject { rcon.command "list" }

    context "when the connection has not been authenticated" do
      before { expect_send_receive }
      let(:response) { not_authenticated_response }

      it { should be_nil }
    end
  end
end
