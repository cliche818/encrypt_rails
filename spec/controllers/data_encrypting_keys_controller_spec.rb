require 'rails_helper'

describe DataEncryptingKeysController, type: :controller do
  describe '#rotate_status' do
    it 'should return a json response for no rotation job in queue or in progress' do
      sidekiq_worker_object = []
      allow(Sidekiq::Workers).to receive(:new).and_return(sidekiq_worker_object)

      sidekiq_queue_object = []
      allow(Sidekiq::Queue).to receive(:new).and_return(sidekiq_queue_object)

      get :rotate_status

      json_response = JSON.parse(response.body)
      expect(json_response).to eq('message' => 'No key rotation queued or in progress')
    end

    it 'should return a json response for key rotation job has been queued' do
      sidekiq_worker_object = []
      allow(Sidekiq::Workers).to receive(:new).and_return(sidekiq_worker_object)

      sidekiq_queue_object = [OpenStruct.new(klass: 'WorkerClass')]
      allow(Sidekiq::Queue).to receive(:new).and_return(sidekiq_queue_object)

      get :rotate_status

      json_response = JSON.parse(response.body)
      expect(json_response).to eq('message' => 'Key rotation has been queued')
    end

    it 'should return a json response for key rotation job in progress' do
      sidekiq_worker_object = double
      allow(sidekiq_worker_object).to receive(:each).and_yield('process_id', 'thread_id', {'payload' =>  {'queue' => 'default'} })
      allow(Sidekiq::Workers).to receive(:new).and_return(sidekiq_worker_object)

      sidekiq_queue_object = []
      allow(Sidekiq::Queue).to receive(:new).and_return(sidekiq_queue_object)

      get :rotate_status

      json_response = JSON.parse(response.body)
      expect(json_response).to eq('message' => 'Key rotation is in progress')
    end
  end
end
