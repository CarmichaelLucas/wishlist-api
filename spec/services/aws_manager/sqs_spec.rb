RSpec.describe AWSManager::SQS do
  
  let!(:sqs_client) { Aws::SQS::Client.new(stub_responses: true) }
  
  let!(:data) do 
    {
      message_body: { email: 'teste@teste.com'},
      message_group_id: 'teste',
      message_deduplication_id: 'teste'
    } 
  end

  it 'is send message to sqs with success' do
    expect(Aws::SQS::Client).to receive(:new) { sqs_client }
    expect(subject.send_message(data: data)).to be_truthy
  end

  it 'is send message to sqs with fail' do
    expect(Aws::SQS::Client).to receive(:new) { sqs_client }
    expect(sqs_client).to receive(:send_message).and_raise(StandardError)
    
    expect{subject.send_message(data: data)}.to raise_error(/Error sending message: StandardError/)
  
  end

end