class RotateKeyWorker
  include Sidekiq::Worker

  def perform
    new_key_record = DataEncryptingKey.generate!(primary: true)

    DataEncryptingKey.where("id <> #{new_key_record.id}").update_all(primary: false)

    EncryptedString.all.each do |encrypted_string|
      value = encrypted_string.value
      encrypted_string.data_encrypting_key = new_key_record
      encrypted_string.value = value

      encrypted_string.save!
    end

    DataEncryptingKey.delete_all(primary: false)
  end
end
