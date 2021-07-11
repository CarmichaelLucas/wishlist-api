# frozen_string_literal: true

class ListerApplication

  def initialize(params)
    @page = params[:page] || nil
    @per_page = params[:per_page] || nil
  end

  def filter(obj)
    result = eval(obj).all.page(@page).per(@per_page)
    q = result.ransack(query)
    q.result
  end

  def query; raise 'Method abstract, implement at your class!'; end
end
