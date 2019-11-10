require 'spec_helper'

RSpec.describe OfficeBoy::Request do
  describe '.call' do
    let(:method_name) { :post }
    let(:path) { 'path' }
    let(:payload) do
      {
        param: 'value'
      }
    end

    before do
      allow(RestClient::Request).to receive(:execute).with(
        method: method_name,
        url: "https://api.sendgrid.com/v3/#{path}",
        payload: JSON.generate(payload),
        headers: {
          'Authorization' => "Bearer test_api_key",
          'Content-Type' => 'application/json'
        }
      )
    end

    context 'when API key is not provided' do
      before do
        OfficeBoy.configure do |config|
          config.sendgrid_api_key = nil
        end
      end

      it 'raises error' do
        expect do
          described_class.call(
            method_name: :post,
            path: 'path',
            payload: ''
          )
        end.to raise_error(OfficeBoy::Errors::NotDefiniedApiKey)
      end
    end

    context 'when API key is provided' do
      before do
        OfficeBoy.configure do |config|
          config.sendgrid_api_key = 'test_api_key'
        end
      end

      it 'sends request' do
        described_class.call(
          method_name: method_name,
          path: path,
          payload: payload
        )

        expect(RestClient::Request).to have_received(:execute).with(
          method: method_name,
          url: "https://api.sendgrid.com/v3/#{path}",
          payload: JSON.generate(payload),
          headers: {
            'Authorization' => "Bearer test_api_key",
            'Content-Type' => 'application/json'
          }
        ).once
      end
    end
  end
end
