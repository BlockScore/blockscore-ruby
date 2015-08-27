module BlockScore
  RSpec.describe NoAPIKeyError do
    it do
      without_authentication
      expect { create(:person_params).save }.to raise_error(described_class) do |raised|
        expect(raised.message).to eq('No API key was provided.')
      end
      with_authentication
    end
  end
end