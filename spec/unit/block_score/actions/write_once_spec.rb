require 'faker'

RSpec.describe BlockScore::Actions::WriteOnce, vcr: true do
  describe '#save!' do
    context 'when creating a new person' do
      subject(:person) { build(:person) }
      before { person.save! }

      it { is_expected.to be_persisted }
      its(:name_first) { is_expected.not_to be_empty }
    end

    context 'when updating an existing person' do
      subject(:person) { create(:person, name_first: 'John') }

      it 'prevents saving' do
        expect(person.persisted?).to be true
        expect { person.save! }
          .to raise_error(BlockScore::Error, 'person is immutable once saved')
      end
    end
  end

  context 'object is immutable' do
    subject(:person) { build(:person, name_first: 'John') }

    it 'prevents alteration' do
      person.save!

      expect { person.bad = 'Jane' }
        .to raise_error(BlockScore::Error, 'person is immutable once saved')
    end
  end
end
