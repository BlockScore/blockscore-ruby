module BlockScore
  RSpec.describe NotFoundError do
    subject { -> { BlockScore::Person.retrieve('abc123') } }

    it_behaves_like 'an error'
  end
end
