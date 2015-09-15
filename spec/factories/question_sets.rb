require 'factory_girl'
require 'faker'

FactoryGirl.define do
  factory :question_set, class: 'BlockScore::QuestionSet' do
    person_id { create(:valid_person).id }
  end
end
