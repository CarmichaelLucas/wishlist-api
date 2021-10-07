require 'net/http'


module SinatraManager
  class Rest
    def get_test
      uri = URI.parse("http://sinatra:4567/test")
      @response = Net::HTTP.get_response(uri)
      
      return @response.error! if @response.error_type.eql?(Net::HTTPFatalError)

      @response
    end
  end
end