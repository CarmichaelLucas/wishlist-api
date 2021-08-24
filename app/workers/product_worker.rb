class ProductWorker
  include Sidekiq::Worker

  def perform(product)
    worker = ProductManager::Creator.new
    worker.execute_creating!(product)
  end
end
