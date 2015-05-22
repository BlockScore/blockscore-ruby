require File.expand_path(File.join(__FILE__, '../test_helper'))

class QuestionSetResourceTest < Minitest::Test
  # QuestionSetResourceTest cannot include ResourceTest because
  # QuestionSets are only accessible through their Person.

  def test_create_question_set
    person = TestClient.create_person
    response = person.question_set.create
    assert_equal response.class, BlockScore::QuestionSet
  end

  def test_retrieve_question_set
    person = TestClient.create_person
    qs = person.question_set.create
    response = person.question_set.retrieve(qs.id)
    assert_equal response.class, BlockScore::QuestionSet
  end

  def test_list_question_set
    person = TestClient.create_person
    response = person.question_set.all # list ALL question_sets
    assert_equal response.class, Array
  end

  def test_list_question_set_with_count
    person = TestClient.create_person
    response = person.question_set.all(:count => 2)
    assert_equal response.class, Array
  end

  def test_list_question_set_with_count_and_offset
    person = TestClient.create_person
    response = person.question_set.all(:count => 2, :offset => 2)
    assert_equal response.class, Array
  end
  
  def test_score
    question_set = TestClient.create_question_set
    @answers = [
      {
        :question_id => 1,
        :answer_id => 1
      },
      {
        :question_id => 2,
        :answer_id => 1
      },
      {
        :question_id => 3,
        :answer_id => 1
      },
      {
        :question_id => 4,
        :answer_id => 1
      },
      {
        :question_id => 5,
        :answer_id => 1
      }
    ]

    response = question_set.score(@answers)
    assert_equal response.class, BlockScore::QuestionSet
  end
end
