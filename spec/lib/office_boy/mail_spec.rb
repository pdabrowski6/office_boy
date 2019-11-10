require 'spec_helper'

RSpec.describe OfficeBoy::Mail do
  describe '.deliver' do
    let(:attributes) do
      {
        from_email: 'tom@doe.com',
        from_name: 'Tom',
        to_email: 'john@doe.com',
        to_name: 'John',
        subject: 'Hello',
        substitutions: {
          key: 'value'
        }
      }
    end

    let(:response) { nil }

    before do
      allow(OfficeBoy::Request).to receive(:call).with(
        method_name: :post,
        path: 'mail/send',
        payload: {
          from: {
            email: attributes[:from_email],
            name: attributes[:from_name]
          },
          template_id: 'template_id',
          personalizations: [
            {
              to: [{
                email: attributes[:to_email],
                name: attributes[:to_name]
              }],
              subject: attributes[:subject]
            }
          ],
          headers: attributes[:substitutions]
        }
      ).and_return(response)
    end

    it 'raises error when template is not defined' do
      expect {
        described_class.deliver(template: :fake, attributes: {})
      }.to raise_error(OfficeBoy::Errors::NotDefiniedEmailTemplate)
    end

    context 'when email is sent successfuly' do
      let(:response) { double(code: 202) }

      it 'returns true' do
        expect(
          described_class.deliver(template: :test_template, attributes: attributes)
        ).to eq(true)
      end
    end

    context 'when email is not sent successfuly' do
      let(:response) { double(code: 400) }

      it 'returns false' do
        expect(
          described_class.deliver(template: :test_template, attributes: attributes)
        ).to eq(false)
      end
    end
  end
end
