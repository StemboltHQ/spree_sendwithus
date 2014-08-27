module Spree
  module SendWithUsMailer
    class Base
      class_attribute :defaults
      class_attribute :default_url_options

      self.defaults = {}.freeze
      self.default_url_options = ActionMailer::Base.default_url_options

      class << self
        def default(value = nil)
          self.defaults = defaults.merge(value).freeze if value
          defaults
        end

        def mailer_methods
          public_instance_methods - superclass.public_instance_methods
        end

        def method_missing(method_name, *args)
          if mailer_methods.include?(method_name.to_sym)
            new(method_name, *args).message
          else
            super
          end
        end
      end

      attr_reader :message

      def initialize(method_name, *args)
        @message = Spree::SendWithUs::Message.new
        self.send(method_name, *args)
      end

      def mail(params = {})
        @message.merge!(self.class.defaults.merge(params))
      end

      def assign(key, value)
        @message.assign(key, value)
      end

      ActiveSupport.run_load_hooks(:spree_sendwithus_mailer, self)
    end
  end
end
