module OfficeBoy
  class Subscriber
    class << self
      def add(list:, attributes:)
        raise Errors::NotDefiniedSubscriptionList unless OfficeBoy.configuration.lists.key?(list)

        list_id = OfficeBoy.configuration.lists[list]

        params = {
          'list_ids' => [list_id],
          'contacts' => [attributes]
        }

        response = OfficeBoy::Request.call(
          method_name: :put,
          path: 'marketing/contacts',
          payload: params
        )

        response.code == 202
      end

      def remove(list:, email:)
        raise Errors::NotDefiniedSubscriptionList unless OfficeBoy.configuration.lists.key?(list)

        list_id = OfficeBoy.configuration.lists[list]

        subscriber =  find(list: list_id, email: email)

        raise Errors::SubscriberNotFound unless subscriber

        response = OfficeBoy::Request.call(
          method_name: :delete,
          path: "marketing/contacts?ids=#{subscriber['id']}"
        )

        response.code == 202
      end

      def find(list:, email:)
        query = "primary_email LIKE '#{email}%' AND CONTAINS(list_ids, '#{list}')"

        response = OfficeBoy::Request.call(
          method_name: :post,
          path: 'marketing/contacts/search',
          payload: { query: query }
        )

        parsed_response = JSON.parse(response.body)
        return unless parsed_response['result'].size == 1

        parsed_response['result'].first
      end
    end
  end
end
