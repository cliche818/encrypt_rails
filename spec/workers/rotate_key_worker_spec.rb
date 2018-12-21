require 'rails_helper'

describe RotateKeyWorker do
  describe '#perform' do
    it 'should execute the rotate key process' do
      old_encrypting_key_record = DataEncryptingKey.generate!(primary: true)
      old_encrypting_key = old_encrypting_key_record.key
      old_encrypting_key_record_id = old_encrypting_key_record.id

      record_one = EncryptedString.create!(value: 'one')
      record_two = EncryptedString.create!(value: 'two')

      old_record_one_encrypted_value = record_one.encrypted_value
      old_record_two_encrypted_value = record_two.encrypted_value

      RotateKeyWorker.new.perform

      expect(DataEncryptingKey.primary.key).to_not eq(old_encrypting_key)
      expect(DataEncryptingKey.find_by(id: old_encrypting_key_record_id)).to be_nil

      updated_record_one = EncryptedString.find(record_one.id)

      expect(updated_record_one.value).to eq('one')
      expect(updated_record_one.encrypted_value).to_not eq(old_record_one_encrypted_value)

      updated_record_two = EncryptedString.find(record_two.id)

      expect(updated_record_two.value).to eq('two')
      expect(updated_record_two.encrypted_value).to_not eq(old_record_two_encrypted_value)
    end

    it 'should generate a data encrypting key if there is no encrypted keys' do
      RotateKeyWorker.new.perform
      expect(DataEncryptingKey.count).to eq(1)
      expect(DataEncryptingKey.primary).to_not be_nil
      expect(EncryptedString.count).to eq(0)
    end
  end
end
