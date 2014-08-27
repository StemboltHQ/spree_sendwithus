module SpreeSendwithus
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_sendwithus'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer "sendwithus_mailer.set_configs" do |app|
      ActiveSupport.on_load(:spree_sendwithus_mailer) do
        include AbstractController::UrlFor
        extend ::AbstractController::Railties::RoutesHelpers.with(app.routes)
        include app.routes.mounted_helpers

        if Object.const_defined?("Delayed::DelayMail")
          extend Delayed::DelayMail
        end
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
