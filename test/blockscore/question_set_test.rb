require File.expand_path(File.join(__FILE__, '../../test_helper'))

class QuestionSetResourceTest < Minitest::Test
  def setup
    super()
    @person = create_person
  end

  def test_create
    count = @person.question_sets.count
    question_set = @person.question_sets.create

    assert question_set.kind_of?(BlockScore::QuestionSet)
    assert_requested(@api_stub, times: 2)
  end

  def test_create_question_set_count
    count = @person.question_sets.count
    @person.question_sets.create

    assert count + 1, @person.question_sets.count
    assert_requested(@api_stub, times: 2)
  end

  def test_retrieve
    qs = @person.question_sets.create
    response = @person.question_sets.retrieve(qs.id)
    assert response.kind_of?(BlockScore::QuestionSet)
    assert_requested(@api_stub, times: 3)
  end

  def test_all
    response = @person.question_sets.all

    assert response.kind_of?(Array)
    response.each { |qs| assert qs.kind_of?(BlockScore::QuestionSet) }
    assert_requested(@api_stub, times: 2)
  end

  def test_all_count
    response = @person.question_sets.all(count: 2)

    assert response.kind_of?(Array)
    assert_equal 2, response.count
    response.each { |qs| assert qs.kind_of?(BlockScore::QuestionSet) }
    assert_requested(@api_stub, times: 2)
  end

  def test_all_offset
    response = @person.question_sets.all(count: 2, offset: 2)

    assert response.kind_of?(Array)
    assert_equal 2, response.count
    response.each { |qs| assert qs.kind_of?(BlockScore::QuestionSet) }
    assert_requested(@api_stub, times: 2)
  end

  def test_score_request
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

  def test_score_attribute
    qs = @person.question_sets.create
    score = qs.score
    assert score.kind_of?(Float)
  end

  def test_score_does_not_request
    qs = @person.question_sets.create
    qs.score
    # 1 for person creation, 1 for question_set creation, 0 for score
    assert_requested(@api_stub, times: 2)
  end
end
