

module ProductManager
  class Creator
    def initialize(products)
      @products = products
    end
  
    def execute_creating!
      Product.create!(@products)
    end
  end
end
