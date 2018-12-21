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

  describe 'updating existing records' do
    it 'should utilize another primary data_encrypting_key to re-encrypt an existing value' do
      first_key = DataEncryptingKey.generate!(primary: true)
      record = EncryptedString.create!(value: 'test_value')
      initial_encrypted_value = record.encrypted_value
      expect(record.value).to eq('test_value')
      expect(record.encrypted_value).to_not eq('test_value')

      DataEncryptingKey.generate!(primary: true)
      first_key.update_attribute(:primary, false)
      record.update_attribute(:value, record.value)

      expect(record.value).to eq('test_value')
      expect(record.encrypted_value).to_not eq(initial_encrypted_value)
    end
  end
end
