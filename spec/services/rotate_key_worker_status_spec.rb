require 'rails_helper'

describe RotateKeyWorkerStatus do
  describe 'return a status for the rotate key worker job' do
    it 'should return a json response for no rotation job in queue or in progress' do
      sidekiq_worker_object = []
      allow(Sidekiq::Workers).to receive(:new).and_return(sidekiq_worker_object)

      sidekiq_queue_object = []
      allow(Sidekiq::Queue).to receive(:new).with(:rotate_key).and_return(sidekiq_queue_object)

      expect(RotateKeyWorkerStatus.status).to eq(:available)
    end

    it 'should return a json response for key rotation job has been queued' do
      sidekiq_worker_object = []
      allow(Sidekiq::Workers).to receive(:new).and_return(sidekiq_worker_object)

      sidekiq_queue_object = [OpenStruct.new(klass: 'WorkerClass')]
      allow(Sidekiq::Queue).to receive(:new).with(:rotate_key).and_return(sidekiq_queue_object)

      expect(RotateKeyWorkerStatus.status).to eq(:queued)
    end

    it 'should return a json response for key rotation job in progress' do
      sidekiq_worker_object = double
      allow(sidekiq_worker_object).to receive(:each).and_yield('process_id', 'thread_id', {'payload' =>  {'queue' => 'default'} })
      allow(Sidekiq::Workers).to receive(:new).and_return(sidekiq_worker_object)

      sidekiq_queue_object = []
      allow(Sidekiq::Queue).to receive(:new).with(:rotate_key).and_return(sidekiq_queue_object)

      expect(RotateKeyWorkerStatus.status).to eq(:in_progress)
    end
  end
end
