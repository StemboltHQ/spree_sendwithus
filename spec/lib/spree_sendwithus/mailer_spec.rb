require 'rails_helper'

describe Spree::SendWithUsMailer::Base do
  class DummyMailer < Spree::SendWithUsMailer::Base
    def test; end;
  end

  subject { DummyMailer }
  it { is_expected.to respond_to(:test) }

  it "raises an undefined method error when method is missing" do
    expect{ DummyMailer.blargh }.to raise_error NoMethodError
  end

  describe "::new" do
    subject { DummyMailer.test }
    it "creates an new message" do
      expect(subject).to be_a Spree::SendWithUs::Message
    end
  end

  describe "::default" do
    it { should respond_to(:default) }
    describe "setting a default" do
      subject { DummyMailer.default({hello: "world"}) }
      it { is_expected.to eq Hash[hello: "world"] }
    end
  end

  describe "::mailer_methods" do
    subject { DummyMailer.mailer_methods }
    it { is_expected.to eq [:test] }
  end

  describe "#mail" do
    class MailerWithMail < Spree::SendWithUsMailer::Base
      def test
        mail email_id: "template_1234"
      end
    end

    subject { MailerWithMail.test }
    it "merges the values from mail into the message" do
      expect(subject.email_id).to eq "template_1234"
    end
  end

  describe "#assign" do
    class MailerWithAssign < Spree::SendWithUsMailer::Base
      def test
        assign :user, "john"
      end
    end

    subject { MailerWithAssign.test }
    it "sets the (key, value) pair on the message" do
      expect(subject.email_data).to eq Hash[user: "john"]
    end
  end
end
