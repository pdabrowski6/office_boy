module OfficeBoy
  class Request
    def self.call(method_name:, path:, payload: '')
      raise Errors::NotDefiniedApiKey unless OfficeBoy.configuration.sendgrid_api_key

      RestClient::Request.execute(
        method: method_name,
        url: "https://api.sendgrid.com/v3/#{path}",
        payload: JSON.generate(payload),
        headers: {
          'Authorization' => "Bearer #{OfficeBoy.configuration.sendgrid_api_key}",
          'Content-Type' => 'application/json'
        }
      )
    end
  end
end
