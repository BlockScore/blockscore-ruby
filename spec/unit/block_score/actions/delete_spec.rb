require 'faker'

RSpec.describe BlockScore::Actions::Delete, vcr: true do
  describe '#delete' do
    subject(:candidate) { create(:candidate) }
    before { candidate.delete }

    it { is_expected.not_to be_persisted }
    it { expect(candidate.deleted).to be true }
  end
end
