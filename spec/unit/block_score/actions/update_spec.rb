require 'faker'

RSpec.describe BlockScore::Actions::Update, vcr: true do
  describe '#save!' do
    subject(:candidate) { build(:candidate, name_first: 'John') }

    context 'when changing first update candidate' do
      it 'has the same attributes' do
        expect(candidate.persisted?).to be false
        expect(candidate.save!).to be true

        expect(candidate.persisted?).to be true

        candidate.name_first = 'Janie'
        expect(candidate)
          .to receive(:patch)
          .with(kind_of(Pathname),
                hash_including(name_first: 'Janie'))
          .and_call_original

        expect { expect(candidate.save!).to be(true) }
          .not_to change(candidate, :id)
      end
    end
  end
end
