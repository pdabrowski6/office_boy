module OfficeBoy
  class Mail
    def self.deliver(template:, attributes:)
      raise Errors::NotDefiniedEmailTemplate unless OfficeBoy.configuration.templates.key?(template)
    
      response = OfficeBoy::Request.call(
        method_name: :post,
        path: 'mail/send',
        payload: {
          from: {
            email: attributes[:from_email],
            name: attributes[:from_name]
          },
          template_id: OfficeBoy.configuration.templates[template],
          personalizations: [
            {
              to: [{
                email: attributes[:to_email],
                name: attributes[:to_name]
              }],
              subject: attributes[:subject],
              dynamic_template_data: attributes[:dynamic_template_data]
            }
          ]
        }
      )

      response.code == 202
    end
  end
end
