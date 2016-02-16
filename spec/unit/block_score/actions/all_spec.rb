require 'faker'

RSpec.describe BlockScore::Actions::All do
  describe '.all' do
    let(:uniq_token_one) { '4a2c019a1e3c33442644d9f52c7a93f7' }
    let(:uniq_token_two) { 'ba9a680671c6c006c6105aa450837668' }
    let!(:p1) { create(:person, name_first: 'John', name_last: uniq_token_one) }
    let!(:p2) { create(:person, name_first: 'John', name_last: uniq_token_two) }
    subject(:people) { BlockScore::Person.all }

    it { is_expected.not_to be_empty }
    it { expect(people[0].name_last).to eql uniq_token_two }
    it { expect(people[1].name_last).to eql uniq_token_one }
  end
end
