class ClientMailer < ApplicationMailer
  default from: "wellcome@wishlist.com"

  before_action :load_client

  def wellcome
    mail to: @client.email, subject: "Wellcome #{@client.name} :)"
  end

  private
  def load_client
    @client = Client.find(params[:id_client])
  end
end
