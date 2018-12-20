class DataEncryptedKeysController < ApplicationController
  def rotate_status

    if Sidekiq::Queue.new.size > 0
      message = 'Key rotation has been queued'
    else
      message = 'No key rotation queued or in progress'
    end

    render json: {message: message}.to_json
  end
end
