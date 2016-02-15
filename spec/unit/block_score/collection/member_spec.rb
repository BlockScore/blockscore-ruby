RSpec.describe BlockScore::Collection::Member do
  describe '#save' do
    let(:question_set) { BlockScore::QuestionSet.new }
    subject(:member) { described_class.new(person, question_set) }

    context 'unsaved person' do
      let(:person) { BlockScore::Person.new(attributes_for(:person)) }

      it 'saves the person as part of member save' do
        expect(person).to_not be_persisted
        expect(member.save).to be true
        expect(person).to be_persisted
      end
    end

    context 'previously saved person' do
      let(:person) { BlockScore::Person.create(attributes_for(:person)) }

      it 'contains the proper fields' do
        expect(member.save).to be true
        expect(person).to be_persisted
        expect(person.attributes.fetch(:question_sets))
          .to eql([question_set.id])
        expect(member).to be_an_instance_of described_class
        expect(member.person_id).to eql person.id

        member.save
        expect(person.attributes.fetch(:question_sets))
          .to eql([question_set.id])
      end
    end
  end
end
