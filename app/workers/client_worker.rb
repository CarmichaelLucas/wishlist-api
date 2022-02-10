class ClientWorker
  include Sidekiq::Worker

  def perform(client_id)
    ClientManager::SendEmailWelcomeSQS.new(client_id).execute
  end
end
