class DataEncryptingKeysController < ApplicationController
  MESSAGE_LOOKUP = {
      RotateKeyWorkerStatus::AVAILABLE => 'No key rotation queued or in progress',
      RotateKeyWorkerStatus::QUEUED => 'Key rotation has been queued',
      RotateKeyWorkerStatus::IN_PROGRESS => 'Key rotation is in progress',
  }.freeze

  def rotate_status
    message = MESSAGE_LOOKUP[RotateKeyWorkerStatus.status]

    render json: {message: message}.to_json
  end

  def rotate
    status = RotateKeyWorkerStatus.status
    message = MESSAGE_LOOKUP[status]

    if status == RotateKeyWorkerStatus::AVAILABLE
      RotateKeyWorker.perform_async
      render json: {message: message}.to_json
    elsif status == RotateKeyWorkerStatus::IN_PROGRESS || status == RotateKeyWorkerStatus::QUEUED
      render json: {message: message}.to_json, status: :service_unavailable
    end
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
