module AWSManager
  class AWS
    def credentials
      {
        access_key_id: @access_key_id,
        secret_access_key: @secret_access_key,
        region: @region
      } 
    end

    def queue_url
      @queue_url  
    end

    private
    def initialize
      @access_key_id = Rails.application.credentials.aws[:access_key_id]
      @secret_access_key = Rails.application.credentials.aws[:secret_access_key]
      @region = Rails.application.credentials.aws[:region]
      @queue_url = Rails.application.credentials.aws[:sqs][:queue_url]
    end
  end
end