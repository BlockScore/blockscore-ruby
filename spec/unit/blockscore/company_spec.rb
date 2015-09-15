module BlockScore
  RSpec.describe Company do
    describe '.new' do
      subject(:company) do
        BlockScore::Company.new(
          entity_name: Faker::Company.name,
          tax_id: '000000000',
          incorporation_country_code: Faker::Address.country_code,
          incorporation_type: 'corporation',
          address_street1: Faker::Address.street_address,
          address_city: Faker::Address.city,
          address_subdivision: Faker::Address.state_abbr,
          address_postal_code: Faker::Address.postcode,
          address_country_code: Faker::Address.country_code
        )
      end

      it { is_expected.not_to be_persisted }
      it { expect(company.class).to be BlockScore::Company }
    end

    describe '.create' do
      context 'vaild company' do
        subject(:company) do
          BlockScore::Company.create(
            entity_name: Faker::Company.name,
            tax_id: '000000000',
            incorporation_country_code: Faker::Address.country_code,
            incorporation_type: 'corporation',
            address_street1: Faker::Address.street_address,
            address_city: Faker::Address.city,
            address_subdivision: Faker::Address.state_abbr,
            address_postal_code: Faker::Address.postcode,
            address_country_code: Faker::Address.country_code
          )
        end

        it { is_expected.to be_persisted }
        it { expect(company.class).to be BlockScore::Company }
      end

      context 'invalid company' do
        subject(:company) do
          BlockScore::Company.create(
            entity_name: Faker::Company.name,
            tax_id: '000000001',
            incorporation_country_code: Faker::Address.country_code,
            incorporation_type: 'corporation',
            address_street1: Faker::Address.street_address,
            address_city: Faker::Address.city,
            address_subdivision: Faker::Address.state_abbr,
            address_postal_code: Faker::Address.postcode,
            address_country_code: Faker::Address.country_code
          )
        end

        it { is_expected.to be_persisted }
        it { expect(company.class).to be BlockScore::Company }
      end
    end

    pending '.find' do
      context 'valid company id' do
        let(:company_id)  { create(:company).id }
        subject(:company) { BlockScore::Company.find(company_id) }

        it { is_expected.to be_persisted }
        it { expect(company.entity_name).not_to be_empty }
        it { expect(company.class).to be BlockScore::Company }
      end

      context 'invalid company id' do
        let(:company_id) { 'e61fa4a8cf1426cdf5befd36abfb7300' }

        it { expect { BlockScore::Company.find(company_id) }.to raise_error BlockScore::RecordNotFound }
      end
    end

    describe '.retrieve' do
      let(:company_id)  { create(:company).id }
      subject(:company) { BlockScore::Company.retrieve(company_id) }

      it { is_expected.to be_persisted }
      it { expect(company.entity_name).not_to be_empty }
      it { expect(company.class).to be BlockScore::Company }
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

      it { expect(company.entity_name).to eq 'BlockScore' }
    end

    describe '#inspect' do
      subject(:company_inspection) { create(:company).inspect }
      it { expect(company_inspection.class).to be String }
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
      it { expect(company.class).to be BlockScore::Company }
    end
  end
end
