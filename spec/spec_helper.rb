require 'rspec'
require 'office_boy'

OfficeBoy.configure do |config|
  config.sendgrid_api_key = 'test_api_key'
  config.lists = {
    test_list: 'list_id'
  }
  config.templates = {
    test_template: 'template_id'
  }
end
