RSpec.describe ApplicationManager::Lister do 
  let(:params) { {} }
  subject(:lister) { described_class.new(params) }
  let(:filter) { lister.filter(build) }
  let(:query) { lister.query }
  let(:build) { lister.build }

  describe '#filter' do
    it { expect{ filter }.to raise_error(NotImplementedError, 'Method abstract, implement at your class!') }
  end

  describe '#build' do
    it { expect{ build }.to raise_error(NotImplementedError, 'Method abstract, implement at your class!') }
  end

  describe '#query' do
    it{ expect{ query }.to raise_error(NotImplementedError, 'Method abstract, implement at your class!') }
  end
end
