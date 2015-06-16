require File.expand_path(File.join(__FILE__, '../../test_helper'))

class QuestionSetResourceTest < Minitest::Test
  context 'BlockScore::QuestionSet' do
    setup do
      @person = create_person
    end

    should 'QuestionSet#create should create a new QuestionSet' do
      count = @person.question_sets.count
      question_set = @person.question_sets.create

      assert question_set.kind_of?(BlockScore::QuestionSet)
      assert_requested(@api_stub, times: 2)
    end

    should 'creating a new QuestionSet should increment the question_sets count' do
      count = @person.question_sets.count
      @person.question_sets.create

      assert count + 1, @person.question_sets.count
      assert_requested(@api_stub, times: 2)
    end

    should 'QuestionSet#retrieve should retrieve a QuestionSet' do
      qs = @person.question_sets.create
      response = @person.question_sets.retrieve(qs.id)
      assert response.kind_of?(BlockScore::QuestionSet)
      assert_requested(@api_stub, times: 3)
    end

    should 'QuestionSet#all should return a list of QuestionSets' do
      response = @person.question_sets.all

      assert response.kind_of?(Array)
      response.each { |qs| assert qs.kind_of?(BlockScore::QuestionSet) }
      assert_requested(@api_stub, times: 2)
    end

    should 'QuestionSet#all with count should return a list of QuestionSets' do
      response = @person.question_sets.all(count: 2)

      assert response.kind_of?(Array)
      assert_equal 2, response.count
      response.each { |qs| assert qs.kind_of?(BlockScore::QuestionSet) }
      assert_requested(@api_stub, times: 2)
    end

    should 'QuestionSet#all with offset should return a list of QuestionSets' do
      response = @person.question_sets.all(count: 2, offset: 2)

      assert response.kind_of?(Array)
      assert_equal 2, response.count
      response.each { |qs| assert qs.kind_of?(BlockScore::QuestionSet) }
      assert_requested(@api_stub, times: 2)
    end

    should 'QuestionSet#score with params should score a QuestionSet' do
      @answers = [
        { question_id: 1, answer_id: 1 },
        { question_id: 2, answer_id: 1 },
        { question_id: 3, answer_id: 1 },
        { question_id: 4, answer_id: 1 },
        { question_id: 5, answer_id: 1 }
      ]

      qs = @person.question_sets.create
      response = qs.score(@answers)
      assert response.kind_of?(BlockScore::QuestionSet)
      assert_requested(@api_stub, times: 3)
    end

    should 'QuestionSet#score without params should return the score of a QuestionSet' do
      qs = @person.question_sets.create
      score = qs.score
      assert score.kind_of?(Float)
    end

    should 'QuestionSet#score without params should not make a request' do
      qs = @person.question_sets.create
      qs.score
      # 1 for person creation, 1 for question_set creation, 0 for score
      assert_requested(@api_stub, times: 2)
    end
  end
end
