class ClientWorker
  include Sidekiq::Worker

  def perform(client_id)
    ClientManager::SendEmailWelcomeSQS.new.execute(client_id)
  end
end
