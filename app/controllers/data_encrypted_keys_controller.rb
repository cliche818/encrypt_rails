class DataEncryptedKeysController < ApplicationController
  def rotate_status
    render json: {message: 'No key rotation queued or in progress'}.to_json
  end
end
