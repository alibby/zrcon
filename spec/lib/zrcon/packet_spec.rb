require "spec_helper"

describe Zrcon::Packet do
  describe '#initialize' do
    context "defaults" do
      it "should set the id to zero" do
        expect(subject.id).to eq 0
      end

      it "should set the type to 2" do
        expect(subject.type).to eq 2
      end

      it "should set data to an empty string" do
        expect(subject.data).to eq ""
      end
    end

    context "subsequent constructor calls" do
      before do
        described_class.class_variable_set :@@id, 0
      end

      it "should increment the id" do
        expect(subject.id).to eq 1
      end
    end

    context "when passed options" do
      let(:id) { 1234 }
      let(:type) { 3 }
      let(:data) { "data"}

      subject { described_class.new id: id, type: type, data: data }

      it "should set the ID" do
        expect(subject.id).to eq id
      end

      it "should set the type" do
        expect(subject.type).to eq type
      end

      it "should set the data" do
        expect(subject.data).to eq data
      end
    end

    describe "::auth" do
      subject { described_class.auth "password" }

      it "should create a packet" do
        expect(described_class)
          .to receive(:new)
          .with(type: 3, data: "password")
        subject
      end
    end

    describe "::command" do
      subject { described_class.command "help" }

      it "should create a packet" do
        expect(described_class)
          .to receive(:new)
          .with(type: 2, data: "help")
        subject
      end
    end

    describe "::decode" do
      let(:command) { "list" }
      let(:id) { 1234 }
      let(:raw) { [id, 2, command].pack("l<l<Z*x") }

      subject { described_class.decode raw }

      it "should have the correct id" do
        expect(subject.id).to eq id
      end

      it "should have the coorrect type" do
        expect(subject.type).to eq 2
      end

      it "shoudl have the correct data" do
        expect(subject.data).to eq command
      end
    end
  end
end

