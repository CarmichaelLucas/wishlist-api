require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe SendEmailWorker, type: :worker do
  let(:id_client) { 1 }
  let(:worker) { described_class.perform_in(id_client) }

  it { expect(SendEmailWorker.new).to respond_to(:perform) }
  it { expect{ worker }.to change(SendEmailWorker.jobs, :size).by(1) }
end
