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
      @access_key_id = ENV['AWS_ACCESS_KEY_ID']
      @secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
      @region = ENV['AWS_REGION']
      @queue_url = ENV['AWS_SQS_QUEUE_URL']
    end
  end
end