require 'pry'

class DataEncryptedKeysController < ApplicationController
  def rotate_status

    if Sidekiq::Queue.new.size > 0
      message = 'Key rotation has been queued'
    elsif key_rotation_job_in_progress?
      message = 'Key rotation is in progress'
    else
      message = 'No key rotation queued or in progress'
    end

    render json: {message: message}.to_json
  end

  private

  def key_rotation_job_in_progress?
    workers = Sidekiq::Workers.new

    result = false
    workers.each do |_process_id, _thread_id, work|
      result = true if work['payload']['queue'].present?
    end

    result
  end
end
