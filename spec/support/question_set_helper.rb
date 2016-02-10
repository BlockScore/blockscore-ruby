module QuestionSetHelper
  VALID_ANSWERS = [
    '309 Colver Rd'.freeze,
    '812'.freeze,
    'Jasper'.freeze,
    '49230'.freeze,
    'None Of The Above'.freeze
  ].freeze

  def self.correct_answers(questions)
    answers(questions, true)
  end

  def self.incorrect_answers(questions)
    answers(questions, false)
  end

  def self.answers(questions, correct = true)
    selected_answers = []

    questions.each do |question|
      question.answers.each do |answer|
        next unless VALID_ANSWERS.include? answer.answer

        selected_answers << {
          question_id: question.id,
          answer_id: (correct ? answer.id : (answer.id + 1) % 5)
        }
        break
      end
    end
    selected_answers
  end
end
