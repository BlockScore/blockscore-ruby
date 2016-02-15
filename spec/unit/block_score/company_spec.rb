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

  describe '#delete' do
    subject(:company) { create(:company) }
    it { expect { company.delete }.to raise_error NoMethodError }
  end
end
