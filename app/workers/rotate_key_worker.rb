class RotateKeyWorker
  include Sidekiq::Worker

  def perform
    DataEncryptingKey.generate!
  end
end
