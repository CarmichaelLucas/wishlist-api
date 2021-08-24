require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe ProductWorker, type: :worker do

  let(:product) { attributes_for(:product) }
  let(:worker) { described_class.perform_in(product.to_json) }

  it { expect(ProductWorker.new).to respond_to(:perform) }
  it { expect{ worker }.to change(ProductWorker.jobs, :size).by(1) }
end
