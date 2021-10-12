module ProductManager
  class Creator

    def execute_creating!(product)
      Product.create!(product)
    end
  
    def execute_jobs(products)
      products.each do |product|
        ProductWorker.perform_in(1.minute, product.to_h)
      end
    end
    
  end
end