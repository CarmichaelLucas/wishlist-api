module ClientManager
  class SendEmailWelcomeSQS
    def execute
      execute_request
    end

    private

    attr_accessor :client_id

    def execute_request
      send_message!
    end

    def aws_sqs
      @sqs ||= AWSManager::SQS.new
    end

    def send_message!
      aws_sqs.send_message(data: payload)
    end
    
    def payload
      {
        message_body: job_args,
        message_group_id: "#{@client.id}",
        message_deduplication_id: "#{@client.id}"
      }
    end

    def client
      @client ||= Client.find(client_id)
    end

    def job_args
      {
        job_class: "ReceiveMessageSqsJob",                                                                                                                        
        job_id: "#{Random.uuid}",                                                                                                           
        provider_job_id: nil,                                                                                                                                     
        queue_name: "wishlist-email-service.fifo",          
        priority: nil,                                      
        arguments: [
          {
            suject: "Welcome #{client.name}",
            email: "#{client.email}",
            name: "#{client.name}",
            type: 'send_email_welcome_to_client' 
          }
        ],                       
        executions: 0,                                      
        exception_executions: {},                           
        locale: "en",                                       
        timezone: "UTC",                                    
        enqueued_at: "#{Time.zone.now}"
      }
    end

    def initialize(client_id)
      @client_id = client_id
    end
  end
end