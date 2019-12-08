# Office Boy

Start with creating `config/initializers/office_boy.rb` initializer:

```ruby
OfficeBoy.configure do |config|
  config.sendgrid_api_key = 'api_key'

  # Contact lists
  config.lists = {
    blog_subscribers: '38bbd55-4ac9-31'
  }

  # Transactional templates
  config.templates = {
    welcome_subscriber: 'd-6955c2836821d0'
  }
end
```

## Adding subscribers

```ruby
contact_attributes = {
  'first_name' => 'John',
  'last_name' => 'Doe',
  'email' => 'johndoe@somedomain.com'
}

OfficeBoy.add_subscriber(
  list: :blog_subscribers,
  attributes: contact_attributes
)
```

## Removing subscribers

```ruby
OfficeBoy.remove_subscriber(
  list: :blog_subscribers,
  email: 'johndoe@somedomain.com'
)
```

## Sending e-mails

```ruby
OfficeBoy.deliver(
  template: :welcome_subscriber,
  attributes: {
    from_email: 'your email',
    from_name: 'your name',
    to_email: 'johndoe@somedomain.com',
    to_name: 'John Doe',
    subject: 'Welcome on my list!',
    dynamic_template_data: {
      first_name: 'John'
    }
  }
)
```
