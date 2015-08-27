module BlockScore
  RSpec.describe Person do
    it_behaves_like 'a resource'

    describe '#details' do
      it 'does not make a request' do
        create(:person).details
        assert_requested(@api_stub, times: 0)
      end
    end

    describe '#question_sets' do
      it 'does not make a request' do
        create(:person).question_sets
        assert_requested(@api_stub, times: 0)
      end
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
