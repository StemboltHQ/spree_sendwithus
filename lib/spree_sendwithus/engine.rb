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

    initializer "sendwithus_mailer.set_configs" do |app|
      ActiveSupport.on_load(:spree_sendwithus_mailer) do
        include AbstractController::UrlFor
        extend AbstractController::Railties::RoutesHelpers.with(app.routes)
        include app.routes.mounted_helpers

        if defined?(Delayed::DelayMail)
          extend Delayed::DelayMail
        end

        options = app.config.action_mailer
        send(:default_url_options=, options.default_url_options)
      end
    end
  end
end
