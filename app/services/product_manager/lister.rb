# frozen_string_literal: true

module ProductManager
  class Lister < ApplicationManager::Lister
    def initialize(params)
      super({page: params[:page], per_page: params[:per_page]})
      @brand = params[:brand]
      @title = params[:title]
      @price_initial = params[:price_initial]
      @price_final = params[:price_final]
    end

    def build
      filter('Product')
    end

    def query
      {
        price_gteq: @price_initial,
        price_lteq: @price_final,
        brand_cont: @brand,
        title_cont: @title,
        s: 'id desc'
      }
    end
  end
end
