require "rails_helper"

RSpec.describe ClientMailer, type: :mailer do
  describe 'wellcome' do  
    let(:client) { build(:client) }
    let(:mail) { described_class.with(client: client).wellcome.deliver_now! }

    it { expect(mail.subject).to eq("Wellcome #{client.name} :)") }
    it { expect(mail.from).to eq(['wellcome@wishlist.com']) }
    it { expect(mail.to).to eq(["#{client.email}"]) }
    it { expect(mail.body.encoded).to match(client.name) }
  end
end
