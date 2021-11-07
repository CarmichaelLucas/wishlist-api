module AWSManager
  class SQS
    include AWSManager::AWS

    def send_message(data:)
      sqs_client = instance_client_aws_sqs
      message = JSON.generate(data[:message_body])
      
      sqs_client.send_message(
        queue_url: ENV['AWS_SQS_QUEUE_URL'],
        message_body: message,
        message_group_id: data[:message_group_id],
        message_deduplication_id: data[:message_deduplication_id]
      )
      true
    rescue StandardError => exception
      raise "Error sending message: #{exception.message}"
    end

    private
    def instance_client_aws_sqs
      Aws::SQS::Client.new(credentials)
    end
  end
end