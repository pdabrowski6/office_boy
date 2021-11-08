module OfficeBoy
  class Mail
    def self.deliver(template:, attributes:)
      raise Errors::NotDefiniedEmailTemplate unless OfficeBoy.configuration.templates.key?(template)
      
      personalization = {
        to: [{
          email: attributes[:to_email],
          name: attributes[:to_name]
        }],
        subject: attributes[:subject],
        dynamic_template_data: attributes[:dynamic_template_data]
      }

      personalization[:bcc] = [{email: attributes[:bcc_email]}] if attributes[:bcc_email]

      response = OfficeBoy::Request.call(
        method_name: :post,
        path: 'mail/send',
        payload: {
          from: {
            email: attributes[:from_email],
            name: attributes[:from_name]
          },
          template_id: OfficeBoy.configuration.templates[template],
          personalizations: [personalization]
        }
      )

      response.code == 202
    end
  end
end
