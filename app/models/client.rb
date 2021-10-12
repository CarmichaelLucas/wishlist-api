class Client < ApplicationRecord
  has_one :list

  validates :name, :email, presence: true
  validates :email, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  after_create :send_email

  private
  def send_email
    SendEmailWorker.perform_in(1.minute, self.id)
  end
end
