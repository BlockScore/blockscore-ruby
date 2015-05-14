require 'test_helper'
require 'test/unit/active_support'

class QuestionSetResourceTest < ActiveSupport::TestCase
  include ResourceTest

  def test_score
    id = TestClient.create_question_set["id"]
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

    response = TestClient.client.question_sets.score(id, @answers)
    assert_equal 201, response.code
  end
end
