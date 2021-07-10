# frozen_string_literal: true

class Lister
  def initialize(params)
    @name = params[:name] || nil
    @email = params[:email] || nil
    @page = params[:page] || nil
    @per_page = params[:per_page] || nil
  end

  def filter()
    result = Client.all.page(@page).per(@per_page)
    q = result.ransack(query)
    q.result
  end

  def query()
    {
      name_cont: @name,
      email_eq: @email,
      s: 'id desc' 
    }
  end
end
