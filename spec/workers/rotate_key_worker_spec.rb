require 'rails_helper'

describe RotateKeyWorker do
  describe '#perform' do
    it 'should generate a new data encypting key' do
      expect(DataEncryptingKey.count).to eq(0)
      RotateKeyWorker.new.perform
      expect(DataEncryptingKey.count).to eq(1)
    end
  end
end
