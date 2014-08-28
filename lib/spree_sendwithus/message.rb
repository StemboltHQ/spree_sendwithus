require 'send_with_us'

module Spree
  module SendWithUs
    class Message
      attr_reader :to, :from, :email_id, :email_data, :cc, :bcc

      def initialize
        @email_data = {}
        @to = {}
        @from = {}
        @cc = []
        @bcc = []
      end

      def assign(key, value)
        @email_data.merge!(key.to_sym => value)
      end

      def merge!(params = {})
        params.each_pair do |key, value|
          case key
          when :email_id
            @email_id = value
          when :recipient_name
            @to.merge!(name: value)
          when :recipient_address
            @to.merge!(address: value)
          when :from_name
            @from.merge!(name: value)
          when :from_address
            @from.merge!(address: value)
          when :reply_to
            @from.merge!(reply_to: value)
          when :cc
            @cc.concat(value)
          when :bcc
            @bcc.concat(value)
          end
        end
      end

      def deliver
        ::SendWithUs::Api.new.send_with(@email_id, @to, @email_data, @from, @cc, @bcc)
      end
    end
  end
end
