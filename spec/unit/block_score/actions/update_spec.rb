require 'faker'

RSpec.describe BlockScore::Actions::Update, vcr: true do
  describe '#save!' do
    context 'when updating an existing candidate' do
      subject(:candidate) { create(:candidate, name_first: 'John') }
      before do
        candidate.name_first = 'Jane'
        candidate.save!
      end

      it { is_expected.to be_persisted }
      its(:name_first) { is_expected.to eql 'Jane' }
    end
  end
end
