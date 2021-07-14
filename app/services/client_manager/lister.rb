# frozen_string_literal: true

module ClientManager
  class Lister < ApplicationManager::Lister

    def initialize(params)
      super({page: params[:page], per_page: params[:per_page]})
      @name = params[:name] || nil
      @email = params[:email] || nil
    end
    
    def build
      filter('Client')
    end

    def query
      {
        name_cont: @name,
        email_eq: @email,
        s: 'id desc' 
      }
    end
  end
end
