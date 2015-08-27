module BlockScore
  RSpec.describe QuestionSet do
    let(:api_stub) { @api_stub }
    let(:person) { create(:person_params) }

    it 'create' do
      person.question_sets.count
      person.question_sets.create
      assert_requested(api_stub, times: 2)
    end

    it 'create question_set count' do
      count = person.question_sets.count
      person.question_sets.create
      expect(count + 1).to be_truthy
      assert_requested(api_stub, times: 2)
    end

    it 'retrieve' do
      qs = person.question_sets.create
      person.question_sets.retrieve(qs.id)
      assert_requested(api_stub, times: 3)
    end

    describe '#all' do
      it 'requests' do
        person.question_sets.all
        assert_requested(api_stub, times: 2)
      end

      it ':count' do
        response = person.question_sets.all(count: 2)
        expect(response.count).to eq(2)
        assert_requested(api_stub, times: 2)
      end

      it ':offset' do
        response = person.question_sets.all(count: 2, offset: 2)
        expect(response.count).to eq(2)
        assert_requested(api_stub, times: 2)
      end
    end

    describe '#score' do
      let(:answers) do
        [
          { question_id: 1, answer_id: 1 },
          { question_id: 2, answer_id: 1 },
          { question_id: 3, answer_id: 1 },
          { question_id: 4, answer_id: 1 },
          { question_id: 5, answer_id: 1 }
        ]
      end

      it 'score call does request' do
        qs = person.question_sets.create
        qs.score(answers)
        assert_requested(api_stub, times: 3)
      end

      it 'accessor does not request' do
        qs = person.question_sets.create
        qs.score
        assert_requested(api_stub, times: 2)
      end
    end
  end
end
