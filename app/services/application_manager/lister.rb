# frozen_string_literal: true

module ApplicationManager
  class Lister
    def initialize(params)
      @page = params[:page] || nil
      @per_page = params[:per_page] || nil
    end

    def filter(obj)
      result = eval(obj).all.page(@page).per(@per_page)
      q = result.ransack(query)
      q.result
    end

    def build; raise NotImplementedError, 'Method abstract, implement at your class!'; end
    def query; raise NotImplementedError, 'Method abstract, implement at your class!'; end
  end
end
