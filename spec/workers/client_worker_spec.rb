require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe ClientWorker, type: :worker do

  let(:client_id) { create(:client).id }
  let(:worker) { described_class.perform_in(client_id) }

  it { expect(ClientWorker.new).to respond_to(:perform) }
  it { expect{ worker }.to change(ClientWorker.jobs, :size).by(1) }
end
