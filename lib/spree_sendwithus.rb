require 'send_with_us'

require 'spree_core'
require 'spree_sendwithus/mailer'
require 'spree_sendwithus/message'
require 'spree_sendwithus/engine'

module Spree
  module SendWithUs
    class Base
      include ActiveSupport::Configurable
      config_accessor :esp_account, instance_accessor: false
    end
  end
end
