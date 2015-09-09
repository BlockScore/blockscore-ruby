module BlockScore
  RSpec.describe Person do
    let(:api_stub) { @api_stub }
    let(:action) { -> { create(:person).details } }

    context 'when person has existing question sets' do
      let(:person) { create(:person, question_set_count: 1) }
      subject(:question_sets) { person.question_sets }
      its(:size) { should eql(1) }
      its(:ids) { should be(person.attributes[:question_sets]) }
      its(:first) { should be_an_instance_of(QuestionSet) }

      it 'should load attributes' do
        expect(question_sets.first.attributes).not_to be(nil)
      end
    end

    it '#id' do
      person = create(:person)
      expect(person.id).not_to be(nil)
    end

    it '#valid?' do
      person = create(:person, status: 'valid')
      expect(person.valid?).to eq(true)
      expect(person.invalid?).to eq(false)
    end

    it '#invalid?' do
      person = create(:person, status: 'invalid')
      expect(person.invalid?).to eq(true)
      expect(person.valid?).to eq(false)
    end
  end
end
