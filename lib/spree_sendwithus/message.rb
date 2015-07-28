require 'send_with_us'

module Spree
  module SendWithUs
    class Message
      attr_reader :to, :from, :email_id, :email_data, :cc, :bcc, :files,
        :esp_account, :tags, :locale, :version_name

      def initialize
        @email_data = {}
        @to = {}
        @from = {}
        @cc = []
        @bcc = []
        @files = []
        @esp_account = Base.esp_account || ""
        @tags = []
        @locale = 'en-US'
        @version_name = ""
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
          when :files
            @files.concat(value)
          when :esp_account
            @esp_account = value
          when :tags
            @tags = value
          when :locale
            @locale = value
          when :version_name
            @version_name = value
          end
        end
      end

      def deliver
        ::SendWithUs::Api.new.send_email(
          @email_id,
          @to,
          {
            data: @email_data,
            from: @from,
            cc: @cc,
            bcc: @bcc,
            esp_account: @esp_account,
            files: @files,
            tags: @tags,
            locale: @locale,
            version_name: @version_name
          }
        )
      end
    end
  end
end
