RSpec.describe BlockScore::Company do
  describe '.new' do
    subject(:company) { described_class.new(attributes_for(:company)) }

    it { is_expected.not_to be_persisted }
    it { is_expected.to be_an_instance_of described_class }
  end

  describe '.create' do
    context 'valid company' do
      subject(:company) { described_class.create(attributes_for(:company)) }

      it { is_expected.to be_persisted }
      it { is_expected.to be_an_instance_of described_class }
    end

    context 'invalid company' do
      subject(:company) { described_class.create(attributes_for(:invalid_company)) }

      it { is_expected.to be_persisted }
      it { is_expected.to be_an_instance_of described_class }
    end
  end

  describe '.retrieve' do
    let(:company_id) { create(:company).id }
    subject(:company) { described_class.retrieve(company_id) }

    it { is_expected.to be_persisted }
    its(:entity_name) { is_expected.not_to be_empty }
    it { is_expected.to be_an_instance_of described_class }
  end

  describe '.all' do
    let(:uniq_token_one) { '4580ab610751f6f37078329357ff98db' }
    let(:uniq_token_two) { '0f222bcb487f9de689c5c60b854973bc' }
    let!(:c1) { create(:company, entity_name: uniq_token_one) }
    let!(:c2) { create(:company, entity_name: uniq_token_two) }
    subject(:companies) { described_class.all }

    it { expect(companies[0].entity_name).to eql uniq_token_two }
    it { expect(companies[1].entity_name).to eql uniq_token_one }
  end

  describe '#delete' do
    subject(:company) { create(:company) }
    it { expect { company.delete }.to raise_error NoMethodError }
  end

  describe '#save' do
    subject(:company) { build(:company) }
    before { company.save }

    it { is_expected.to be_persisted }
    it { is_expected.to be_an_instance_of described_class }
  end
end
