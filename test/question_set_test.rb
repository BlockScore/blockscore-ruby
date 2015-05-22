require File.expand_path(File.join(__FILE__, '../test_helper'))

class QuestionSetResourceTest < Minitest::Test
  # QuestionSetResourceTest cannot include ResourceTest because
  # QuestionSets are only accessible through their Person.

  def create_person
    TestClient.create_person
  end

  def create_question_set
    create_person.question_set.create
  end

  def list_question_sets(options = {})
    person = create_person

    # Create some QuestionSets before trying to list them all.
    5.times do
      person.question_set.create
    end

    person.question_set.all(options)
  end

  def test_create_question_set
    response = create_question_set
    assert_equal response.class, BlockScore::QuestionSet
  end

  def test_retrieve_question_set
    person = create_person
    qs = person.question_set.create
    response = person.question_set.retrieve(qs.id)
    assert_equal response.class, BlockScore::QuestionSet
  end

  def test_list_question_set
    response = list_question_sets
    assert_equal response.class, Array
  end

  def test_list_question_set_with_count
    response = list_question_sets(:count => 2)
    assert_equal response.class, Array
    assert_equal response.size, 2
  end

  def test_list_question_set_with_count_and_offset
    response = list_question_sets(:count => 2, :offset => 2)
    assert_equal response.class, Array
    assert_equal response.size, 2
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
