require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

describe 'Integration for Rotate Key Job', :type => :feature do
  it 'should execute the rotate key job for 1001 encrypted strings' do
    key = DataEncryptingKey.generate!(primary: true)
    old_key_id = key.id
    (1..1001).each do |x|
      EncryptedString.create(value: x.to_s)
    end

    Sidekiq::Testing.inline! do
      RotateKeyWorker.perform_async

      loop do
        visit '/data_encrypting_keys/rotate/status'

        break if page.body.include?('No key rotation queued or in progress')
      end
    end

    expect(DataEncryptingKey.primary.id).to_not eq(old_key_id)
  end
end
