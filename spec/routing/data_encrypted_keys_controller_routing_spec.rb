require 'rails_helper'

RSpec.describe 'DataEncryptedKeysController', :type => :routing do
  describe 'routing' do
    it 'routes to #rotate_status' do
      expect(get: '/data_encrypting_keys/rotate/status').to route_to('data_encrypted_keys#rotate_status')
    end
  end
end
