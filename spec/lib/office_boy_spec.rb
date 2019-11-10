require 'spec_helper'

RSpec.describe OfficeBoy do
  describe '.deliver' do
    it 'delegates call to OfficeBoy::Mail' do
      expect(OfficeBoy::Mail).to receive(:deliver).with(
        template: :template_id, attributes: {}
      )

      described_class.deliver(template: :template_id, attributes: {})
    end
  end

  describe '.add_subscriber' do
    it 'delegates call to OfficeBoy::Subscriber' do
      expect(OfficeBoy::Subscriber).to receive(:add).with(
        list: :list_id, attributes: {}
      )

      described_class.add_subscriber(list: :list_id, attributes: {})
    end
  end

  describe '.remove_subscriber' do
    it 'delegates call to OfficeBoy::Subscriber' do
      expect(OfficeBoy::Subscriber).to receive(:remove).with(
        list: :list_id, email: 'email'
      )

      described_class.remove_subscriber(list: :list_id, email: 'email')
    end
  end

  describe 'configuration' do
    before do
      OfficeBoy.configure do |config|
        config.sendgrid_api_key = 'conf_api_key'
        config.templates = {
          conf_id: 'conf_value'
        }
        config.lists = {
          conf_id: 'conf_value'
        }
      end
    end

    it 'makes sendgrid api key configurable' do
      expect(
        described_class.configuration.sendgrid_api_key
      ).to eq('conf_api_key')
    end

    it 'makes templates configurable' do
      expect(
        described_class.configuration.templates
      ).to eq({ conf_id: 'conf_value' })
    end

    it 'makes lists configurable' do
      expect(
        described_class.configuration.lists
      ).to eq({ conf_id: 'conf_value' })
    end
  end
end
