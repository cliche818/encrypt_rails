require 'rails_helper'

describe EncryptedString do
  describe 'creating new records' do
    it 'should utilize the primary data_encrypting_key to generated an encrypted value' do
      DataEncryptingKey.generate!(primary: true)
      record = EncryptedString.create!(value: 'test_value')
      expect(record.value).to eq('test_value')
      expect(record.encrypted_value).to_not eq('test_value')
    end
  end
end
