class SendEmailWorker
  include Sidekiq::Worker

  def perform(id)
    ClientMailer.with(id_client: id).wellcome.deliver_now!
  end
end
