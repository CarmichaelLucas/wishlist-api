require 'rails_helper'
RSpec.describe SinatraWorker, type: :worker do
  let(:time) { Time.now }
  let(:worker) { described_class.perform_in(time) }

  it { expect(SinatraWorker.new).to respond_to(:perform) }
  it { expect{ worker }.to change(SinatraWorker.jobs, :size).by(1) }
end
