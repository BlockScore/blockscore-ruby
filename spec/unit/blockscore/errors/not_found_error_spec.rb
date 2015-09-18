module BlockScore
  RSpec.describe NotFoundError do
    subject { -> { BlockScore::Person.retrieve('invalid_id') } }

    it_behaves_like 'an error'
  end
end
