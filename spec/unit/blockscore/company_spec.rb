module BlockScore
  RSpec.describe Company do
    describe '.new' do
      subject(:company) { BlockScore::Company.new(attributes_for(:company)) }

      it { is_expected.not_to be_persisted }
      its(:class) { should be BlockScore::Company }
    end

    describe '.create' do
      context 'valid company' do
        subject(:company) { BlockScore::Company.create(attributes_for(:company)) }

        it { is_expected.to be_persisted }
        its(:class) { should be BlockScore::Company }
      end

      context 'invalid company' do
        subject(:company) { BlockScore::Company.create(attributes_for(:invalid_company)) }

        it { is_expected.to be_persisted }
        its(:class) { should be BlockScore::Company }
      end
    end

    describe '.retrieve' do
      let(:company_id)  { create(:company).id }
      subject(:company) { BlockScore::Company.retrieve(company_id) }

      it { is_expected.to be_persisted }
      its(:entity_name) { is_expected.not_to be_empty }
      its(:class) { should be BlockScore::Company }
    end

    describe '.all' do
      let(:uniq_token_one) { '4580ab610751f6f37078329357ff98db' }
      let(:uniq_token_two) { '0f222bcb487f9de689c5c60b854973bc' }
      subject(:companies) { BlockScore::Company.all }

      before do
        create(:company, entity_name: uniq_token_one)
        create(:company, entity_name: uniq_token_two)
      end

      it { is_expected.not_to be_empty }
      it { expect(companies[0].entity_name).to eq uniq_token_two }
      it { expect(companies[1].entity_name).to eq uniq_token_one }
    end

    describe '#refresh' do
      subject(:company) { create(:company, entity_name: 'BlockScore') }
      before do
        company.entity_name = 'DarkScore'
        company.refresh
      end

      its(:entity_name) { is_expected.to eq 'BlockScore' }
    end

    describe '#inspect' do
      subject(:company_inspection) { create(:company).inspect }

      its(:class) { should be(String) }
      it { is_expected.to match(/^#<BlockScore::Company:0x/) }
    end

    describe '#update' do
      subject(:company) { create(:company) }
      it { expect { company.update(entity_name: 'new_name') }.to raise_error NoMethodError }
    end

    describe '#delete' do
      subject(:company) { create(:company) }
      it { expect { company.delete }.to raise_error NoMethodError }
    end

    describe '#save' do
      subject(:company) { build(:company) }
      before { company.save }

      it { is_expected.to be_persisted }
      its(:class) { should be BlockScore::Company }
    end
  end
end
