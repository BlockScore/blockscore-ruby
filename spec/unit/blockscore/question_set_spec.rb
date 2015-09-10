module BlockScore
  RSpec.describe QuestionSet do
    let(:person) { create(:person_params) }

    describe 'api requests' do
      let(:api_stub) { @api_stub }

      context 'when creating' do
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
      end

      context 'when scoring' do
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
      end
    end

  end
end