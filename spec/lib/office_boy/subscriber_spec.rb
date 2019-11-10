require 'spec_helper'

RSpec.describe OfficeBoy::Subscriber do
  describe '.remove' do
    let(:email) { 'john@doe.com' }

    it 'raises error when given list was not defined' do
      expect {
        described_class.remove(list: :fake_list, email: email)
      }.to raise_error(OfficeBoy::Errors::NotDefiniedSubscriptionList)
    end

    context 'when subscriber is found' do
      let(:subscriber) do
        { 'id' => 123 } 
      end

      before do
        allow(described_class).to receive(:find).with(
          list: 'list_id', email: email
        ).and_return(subscriber)
        stub_request(
          method_name: :delete,
          path: "marketing/contacts?ids=#{subscriber['id']}",
          payload: nil,
          response: response
        )
      end

      context 'when subscriber is removed successfully' do
        let(:response) { double(code: 202) }

        it 'returns true' do
          expect(
            described_class.remove(list: :test_list, email: email)
          ).to eq(true)
        end
      end

      context 'when subscriber is not removed successfully' do
        let(:response) { double(code: 400) }

        it 'returns false' do
          expect(
            described_class.remove(list: :test_list, email: email)
          ).to eq(false)
        end
      end
    end

    context 'when subscriber is not found' do
      before do
        allow(described_class).to receive(:find).with(
          list: 'list_id', email: email
        ).and_return(nil)
      end

      it 'raises error' do
        expect {
          described_class.remove(list: :test_list, email: email)
        }.to raise_error(OfficeBoy::Errors::SubscriberNotFound)
      end
    end
  end

  describe '.find' do
    let(:email) { 'john@doe.com' }
    let(:list)  { 'list_id' }
    let(:query) { "primary_email LIKE '#{email}%' AND CONTAINS(list_ids, '#{list}')" }

    before do
      stub_request(
        method_name: :post,
        path: 'marketing/contacts/search',
        payload: { query: query },
        response: response
      )
    end

    context 'when none of contacts is matched' do
      let(:response) { double(body: JSON.generate({ 'result' => []})) }

      it 'returns nil' do
        expect(
          described_class.find(list: :list_id, email: email)
        ).to eq(nil)
      end
    end

    context 'when multiple contacts are matched' do
      let(:response) { double(body: JSON.generate({ 'result' => [{}, {}]})) }

      it 'returns nil' do
        expect(
          described_class.find(list: :list_id, email: email)
        ).to eq(nil)
      end
    end

    context 'when single contact is matched' do
      let(:contact) { 'contact' }
      let(:response) { double(body: JSON.generate({ 'result' => [contact]})) }

      it 'returns contact' do
        expect(
          described_class.find(list: :list_id, email: email)
        ).to eq(contact)
      end
    end
  end

  describe '.add' do
    let(:attributes) do
      { 'first_name' => 'John', 'last_name' => 'Doe' }
    end

    it 'raises error when given list was not defined' do
      expect {
        described_class.add(list: :fake_list, attributes: attributes)
      }.to raise_error(OfficeBoy::Errors::NotDefiniedSubscriptionList)
    end

    context 'when given list was defined' do
      before do
        stub_request(
          method_name: :put,
          path: 'marketing/contacts',
          payload: {
            'list_ids' => ['list_id'],
            'contacts' => [
              {
                'first_name' => 'John',
                'last_name' => 'Doe'
              }
            ]
          },
          response: response
        )
      end

      context 'when request was successful' do
        let(:response) { double(code: 202) }

        it 'returns true' do
          expect(
            described_class.add(list: :test_list, attributes: attributes)
          ).to eq(true)
        end
      end

      context 'when request was not successful' do
        let(:response) { double(code: 400) }

        it 'returns false' do
          expect(
            described_class.add(list: :test_list, attributes: attributes)
          ).to eq(false)
        end
      end
    end
  end

  def stub_request(method_name:, path:, payload:, response:)
    attributes = {
      method_name: method_name,
      path: path,
    }

    attributes[:payload] = payload if payload

    allow(OfficeBoy::Request).to receive(:call).with(
      attributes
    ).and_return(response)
  end
end
