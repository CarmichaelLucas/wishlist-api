module AWSManager
  class SQS  
    def send_message(data:)
      sqs_client = instance_client_aws_sqs
      message = JSON.generate(data[:message_body])
      
      sqs_client.send_message(
        queue_url: aws_queue_url,
        message_body: message,
        message_group_id: data[:message_group_id],
        message_deduplication_id: data[:message_deduplication_id],
        message_attributes: {
          'shoryuken_class' => {
            string_value: 'ActiveJob::QueueAdapters::ShoryukenAdapter::JobWrapper',
            data_type: 'String'
          }
        }
      )
      true
    rescue StandardError => e
      raise e
    end

    private
    def instance_client_aws_sqs
      Aws::SQS::Client.new(@aws.credentials)
    end

    def aws_queue_url
      @aws.queue_url
    end
    
    def initialize
      @aws = AWSManager::AWS.new
    end
  end
end