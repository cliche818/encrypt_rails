require 'rails_helper'

RSpec.describe DataEncryptingKeysController, type: :routing do
  describe 'routing' do
    it 'routes to #rotate_status' do
      expect(get: '/data_encrypting_keys/rotate/status').to route_to('data_encrypting_keys#rotate_status')
    end

    it 'routes to #rotate' do
      expect(post: '/data_encrypting_keys/rotate').to route_to('data_encrypting_keys#rotate')
    end
  end
end
