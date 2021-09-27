class SinatraWorker
  include Sidekiq::Worker

  def perform
    SinatraManager::Rest.new.get_test
  end
end
