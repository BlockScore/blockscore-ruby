require 'test_helper'
require 'test/unit/active_support'

class QuestionSetResourceTest < ActiveSupport::TestCase
  include ResourceTest

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
    assert_equal resource_to_class(resource), response.class
  end
end
