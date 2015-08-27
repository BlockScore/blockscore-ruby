require File.expand_path(File.join('spec/blockscore/question_set_spec.rb', '../../spec_helper'))

module BlockScore
  RSpec.describe QuestionSet do
    before do
      @person = create(:person_params)
    end

    it 'test_create' do
      @person.question_sets.count
      @person.question_sets.create
      assert_requested(@api_stub, times: 2)
    end

    it 'test_create_question_set_count' do
      count = @person.question_sets.count
      @person.question_sets.create
      expect((count + 1)).to be_truthy
      assert_requested(@api_stub, times: 2)
    end

    it 'test_retrieve' do
      qs = @person.question_sets.create
      @person.question_sets.retrieve(qs.id)
      assert_requested(@api_stub, times: 3)
    end

    it 'test_all' do
      @person.question_sets.all
      assert_requested(@api_stub, times: 2)
    end

    it 'test_all_count' do
      response = @person.question_sets.all(count: 2)
      expect(response.count).to eq(2)
      assert_requested(@api_stub, times: 2)
    end

    it 'test_all_offset' do
      response = @person.question_sets.all(count: 2, offset: 2)
      expect(response.count).to eq(2)
      assert_requested(@api_stub, times: 2)
    end

    it 'test_score_request' do
      answers = [{ question_id: 1, answer_id: 1 }, { question_id: 2, answer_id: 1 }, { question_id: 3, answer_id: 1 }, { question_id: 4, answer_id: 1 }, { question_id: 5, answer_id: 1 }]
      qs = @person.question_sets.create
      qs.score(answers)
      assert_requested(@api_stub, times: 3)
    end

    it 'test_score_does_not_request' do
      qs = @person.question_sets.create
      qs.score
      assert_requested(@api_stub, times: 2)
    end
  end
end
