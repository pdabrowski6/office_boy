require File.expand_path('../lib/office_boy/version', __FILE__)

Gem::Specification.new do |s|
  s.add_development_dependency 'rspec', '~> 3.7', '>= 3.7.0'
  s.add_runtime_dependency 'rest-client'
  s.add_runtime_dependency 'sendgrid-ruby'
  s.name        = 'office_boy'
  s.version     = ::OfficeBoy::Version
  s.date        = '2019-11-07'
  s.summary     = "Wrapper for the Sendgrid API addressed to the technical bloggers"
  s.description = "Wrapper for the Sendgrid API addressed to the technical bloggers"
  s.authors     = ["Paweł Dąbrowski"]
  s.email       = 'dziamber@gmail.com'
  s.files       = Dir['lib/**/*.rb', 'spec/helper.rb']
  s.homepage    =
    'http://github.com/rubyhero/office_boy'
  s.license       = 'MIT'
  s.required_ruby_version = '>= 2.5.0'
end
