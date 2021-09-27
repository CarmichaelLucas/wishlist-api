require 'net/http'


module SinatraManager
  class Rest
    def get_test
      Net::HTTP.get("http://0.0.0.0:4567/test")
    end
  end
end