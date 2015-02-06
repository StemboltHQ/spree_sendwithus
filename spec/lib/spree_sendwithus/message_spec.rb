require 'spree_sendwithus'

describe Spree::SendWithUs::Message do
  subject { Spree::SendWithUs::Message.new }

  it { is_expected.to respond_to(:email_id, :to, :from, :cc, :bcc, :deliver) }
  it { is_expected.not_to respond_to(:email_id=, :to=, :from=, :cc=, :bcc=) }

  describe "initialization" do
    it "creates an empty email_data on initialization" do
      expect(subject.email_data).to be_empty
    end
  end

  describe "#assign" do
    let(:message) { Spree::SendWithUs::Message.new }

    it "adds (key,value) pairs to email_data hash" do
      message.assign(:user, {name: "Richard", email: "richard@example.com"})

      expect(message.email_data).to eq Hash[
        user: {name: "Richard", email: "richard@example.com"}
      ]

      message.assign(:url, "http://test.example.com")
      expect(message.email_data).to eq Hash[
        user: {name: "Richard", email: "richard@example.com"},
        url: "http://test.example.com"
      ]
    end

    it "symbolizes the keys" do
      message.assign("company", "FreeRunning Tech")
      expect(message.email_data).to have_key(:company)
    end
  end

  describe "#merge!" do
    let(:message) { Spree::SendWithUs::Message.new }
    let(:params) { Hash[
      email_id: "template_1234",
      recipient_name: "John",
      recipient_address: "john@example.com",
      from_name: "Jared",
      from_address: "jared@example.com",
      reply_to: "gregor@example.com",
      cc: ["sean@example.com"],
      bcc: ["clarke@example.com", "kyria@example.com"],
      files: ["path/to/file.txt", "../another_file.txt"],
      esp_account: "esp_1234",
      tags: ['thing'],
      locale: "en",
      version_name: "rawr"
    ] }

    before do
      message.merge!(params)
    end

    subject { message }

    it "contains the expected email_id" do
      expect(subject.email_id).to eq "template_1234"
    end
    it "contains the expected to hash" do
      expect(subject.to).to eq Hash[
        name: "John",
        address: "john@example.com"
      ]
    end
    it "contains the expected from hash" do
      expect(subject.from).to eq Hash[
        name: "Jared",
        address: "jared@example.com",
        reply_to: "gregor@example.com"
      ]
    end
    it "contains the expected cc array" do
      expect(subject.cc).to match_array ["sean@example.com"]
    end
    it "contains the expected bcc array" do
      expect(subject.bcc).to match_array [
        "clarke@example.com",
        "kyria@example.com"
      ]
    end
    it "contains the expected files array" do
      expect(subject.files).to match_array [
        "path/to/file.txt",
        "../another_file.txt"
      ]
    end
    it "contains the expected esp account" do
      expect(subject.esp_account).to eq "esp_1234"
    end

    it "contains the expected tags" do
      expect(subject.tags).to eq ['thing']
    end

    it "contains the expected locale" do
      expect(subject.locale).to eq 'en'
    end

    it "contains the expected version_name" do
      expect(subject.version_name).to eq 'rawr'
    end
  end

  describe "#deliver" do
    let(:api_double) { double("api") }

    it "calls the send_with_us gem" do
      allow(SendWithUs::Api).to receive(:new).and_return(api_double)
      expect(api_double).to receive(:send_email)

      subject.deliver
    end
  end
end
