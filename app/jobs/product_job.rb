class ProductJob < ApplicationJob
  queue_as :default

  def perform(params)
    product = ProductManager::Creator.new(params)
    product.execute_creating!
  end
end
