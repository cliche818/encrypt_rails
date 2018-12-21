class RotateKeyWorkerStatus
  QUEUED = :queued
  IN_PROGRESS = :in_progress
  AVAILABLE = :available

  def self.status
    if Sidekiq::Queue.new.size > 0
      QUEUED
    elsif key_rotation_job_in_progress?
      IN_PROGRESS
    else
      AVAILABLE
    end
  end

  class << self
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
end