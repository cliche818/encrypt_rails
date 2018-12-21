require 'rails_helper'

describe DataEncryptingKey do
  describe '.generate!' do
    it 'should generate a key' do
      expect(DataEncryptingKey.count).to eq(0)
      data_encrypting_key = DataEncryptingKey.generate!
      expect(DataEncryptingKey.count).to eq(1)
      expect(data_encrypting_key.key).to be_present
    end
  end
end
