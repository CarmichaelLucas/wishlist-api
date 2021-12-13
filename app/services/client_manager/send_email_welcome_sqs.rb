module ClientManager
  class SendEmailWelcomeSQS
    def execute(client_id)
      @client = Client.find(client_id)
      execute_request
    end

    private

    def execute_request
      sqs = AWSManager::SQS.new
      sqs.send_message(data: payload)
    end
    
    def payload
      {
        message_body: {
          suject: "Welcome #{@client.name}",
          to: "#{@client.email}",
          message: 'Seja Bem vindo!' 
        },
        message_group_id: "#{@client.id}",
        message_deduplication_id: "#{@client.id}"
      }
    end
  end
end