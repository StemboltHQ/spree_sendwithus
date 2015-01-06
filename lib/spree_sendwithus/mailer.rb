module Spree
  module SendWithUsMailer
    class Base < ::ActionMailer::Base
      class_attribute :defaults

      self.defaults = {}.freeze

      class << self
        def default(value = nil)
          self.defaults = defaults.merge(value).freeze if value
          defaults
        end

        def mailer_methods
          methods = public_instance_methods - superclass.public_instance_methods

          # Reject route helper methods.
          methods.reject{ |m| m.to_s.end_with?("_url", "_path") }
        end

        def method_missing(method_name, *args)
          if mailer_methods.include?(method_name.to_sym)
            new(method_name, *args).message
          else
            super(method_name, *args)
          end
        end

        def respond_to?(symbol, include_private = false)
          super || mailer_methods.include?(symbol)
        end
      end

      attr_reader :message
      attr_reader :action

      def initialize(method_name, *args)
        @message = Spree::SendWithUs::Message.new
        @action = method_name
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
