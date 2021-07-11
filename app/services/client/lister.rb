# frozen_string_literal: true

require_relative '../application/lister_application.rb'

class Lister < ListerApplication

  def initialize(params)
    super({page: params[:page], per_page: params[:per_page]})
    @name = params[:name] || nil
    @email = params[:email] || nil
  end
  
  def query()
    {
      name_cont: @name,
      email_eq: @email,
      s: 'id desc' 
    }
  end
end
