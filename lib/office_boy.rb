require 'rest-client'
require 'json'

require 'office_boy/errors/not_definied_subscription_list'
require 'office_boy/errors/not_definied_api_key'
require 'office_boy/errors/subscriber_not_found'
require 'office_boy/errors/not_defined_email_template'

require 'office_boy/subscriber'
require 'office_boy/mail'
require 'office_boy/request'

module OfficeBoy
  # Shortcuts

  class << self
    def deliver(template:, attributes:)
      Mail.deliver(template: template, attributes: attributes)
    end

    def add_subscriber(list:, attributes:)
      Subscriber.add(list: list, attributes: attributes)
    end

    def remove_subscriber(list:, email:)
      Subscriber.remove(list: list, email: email)
    end
  end

  # Configuration

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :sendgrid_api_key, :lists, :templates

    def initialize
      @sendgrid_api_key = nil
      @lists = {}
      @templates = {}
    end
  end
end
