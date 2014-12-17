Spree SendWithUs
================

SendWithUs mailer you can use in Spree! Say what?!

Installation
------------

Add spree_sendwithus to your Gemfile:

```ruby
gem 'spree_sendwithus', github: 'freerunningtech/spree_sendwithus'
```

Bundle your dependencies and run the installation generator:

```shell
bundle install
```

Add `send_with_us.rb` in `config/initializers` with the following:

```ruby
SendWithUs::Api.configure do |config|
  config.api_key = ENV["SEND_WITH_US_API_KEY"]
  config.debug = true
end
```

Now you can configure any of your mailers to use SendWithUs by making them a subclass of `Spree::SendWithUsMailer::Base`. For example:

```ruby
# app/mailers/spree/quality_control_mailer.rb

class Spree::QualityControlMailer < Spree::SendWithUsMailer::Base
  default recipient_name: "Quality Control",
          recipient_address: "quality@freerunningtech.com",
          from_name: "Quality Control",
          from_address: "quality@freerunningtech.com"

  def reprint(original, reprint)
    assign(:original, order_data(Spree::Order.find(original)))
    assign(:reprint, order_data(Spree::Order.find(reprint)))

    mail(
      email_id: 'SEND_WITH_US_TEMPLATE_ID',
      esp_account: 'SEND_WITH_US_ESP_API_ID' # Optional
    )
  end

  private
  def order_data(order)
    {
      url: spree.admin_order_url(order),
      number: order.number
    }
  end
end
```

The mailer will work with delayed job or without:

```ruby
# Delayed
Spree::QualityControlMailer.delay.reprint(1, 2)

# Inline
Spree::QualityControlMailer.reprint(1, 2).deliver
```

Also, the default URL host will be pulled from `config.action_mailer.default_url_options` so there's no need for any extra configuration! You're welcome!

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

```shell
bundle
bundle exec rake test_app
bundle exec rspec spec
```

Copyright (c) 2014 FreeRunning Technologies, released under the New BSD License
