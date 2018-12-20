require 'rails_helper'

RSpec.describe DataEncryptedKeysController, type: :controller do
  describe '#rotate_status' do
    it 'should return a json response for no rotation job in queue or in progress' do
      # sidekiq_queue_object = [OpenStruct.new(klass: 'WorkerClass')]
      # allow(Sidekiq::Queue).to receive(:new).and_return(sidekiq_queue_object)

      get :rotate_status

      json_response = JSON.parse(response.body)
      expect(json_response).to eq('message' => 'No key rotation queued or in progress')
    end

    it 'should return a json response for key rotation job has been queued' do
      sidekiq_queue_object = [OpenStruct.new(klass: 'WorkerClass')]
      allow(Sidekiq::Queue).to receive(:new).and_return(sidekiq_queue_object)

      get :rotate_status

      json_response = JSON.parse(response.body)
      expect(json_response).to eq('message' => 'Key rotation has been queued')
    end
  end
end
