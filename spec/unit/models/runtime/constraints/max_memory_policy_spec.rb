require 'spec_helper'

describe MaxMemoryPolicy do
  let(:app) { VCAP::CloudController::AppFactory.make(memory: 100, state: 'STARTED') }
  let(:org_or_space) { double(:org_or_space, has_remaining_memory: false) }
  let(:error_name) { :random_memory_error }

  subject(:validator) { MaxMemoryPolicy.new(app, org_or_space, error_name) }

  context 'when performing a scaling operation' do
    before do
      app.memory = 150
    end

    it 'registers error when quota is exceeded' do
      allow(org_or_space).to receive(:has_remaining_memory).with(50).and_return(false)
      expect(validator).to validate_with_error(app, :memory, error_name)
    end

    it 'does not register error when quota is not exceeded' do
      allow(org_or_space).to receive(:has_remaining_memory).with(50).and_return(true)
      expect(validator).to validate_without_error(app)
    end

    it 'adds the given error to the model' do
      allow(org_or_space).to receive(:has_remaining_memory).with(50).and_return(false)
      validator.validate
      expect(app.errors.on(:memory)).to include(error_name)
    end
  end

  context 'when not performing a scaling operation' do
    it 'does not register error' do
      app.state = 'STOPPED'
      expect(validator).to validate_without_error(app)
    end
  end

  context 'when the app is process' do
    let(:app) { VCAP::CloudController::AppFactory.make(memory: 100, state: 'STARTED') }
    let(:app_model) { VCAP::CloudController::AppModel.make }
    before do
      app_model.add_process app
    end

    it 'does not register error' do
      expect(validator).to validate_without_error(app)
    end
  end
end
