require 'faker'

RSpec.describe BlockScore::Actions::Update do
  describe '#save!' do
    subject(:candidate) { build(:candidate, name_first: 'John') }

    context 'when changing first update candidate' do
      it 'has the same attributes' do
        expect(candidate.persisted?).to be false
        expect(candidate.save!).to be true

        expect(candidate.persisted?).to be true

        candidate.name_first = 'Janie'
        expect { candidate.save! }.not_to change(candidate, :id)
        expect(candidate.save!).to be true

        result = BlockScore::Candidate.retrieve(candidate.id)
        expect(result.attributes.reject { |key, _| key.equal?(:updated_at) })
          .to eql(candidate.attributes.reject do |key, _|
            key.equal?(:updated_at)
          end)
      end
    end
  end
end
