require 'rails_helper'

describe DataEncryptingKeysController, type: :controller do
  describe '#rotate_status' do
    it 'should return a json response for no rotation job in queue or in progress' do
      allow(RotateKeyWorkerStatus).to receive(:status).and_return(RotateKeyWorkerStatus::AVAILABLE)

      get :rotate_status

      json_response = JSON.parse(response.body)
      expect(json_response).to eq('message' => 'No key rotation queued or in progress')
    end

    it 'should return a json response for key rotation job has been queued' do
      allow(RotateKeyWorkerStatus).to receive(:status).and_return(RotateKeyWorkerStatus::QUEUED)

      get :rotate_status

      json_response = JSON.parse(response.body)
      expect(json_response).to eq('message' => 'Key rotation has been queued')
    end

    it 'should return a json response for key rotation job in progress' do
      allow(RotateKeyWorkerStatus).to receive(:status).and_return(RotateKeyWorkerStatus::IN_PROGRESS)

      get :rotate_status

      json_response = JSON.parse(response.body)
      expect(json_response).to eq('message' => 'Key rotation is in progress')
    end
  end

  describe '#rotate' do

  end
end
