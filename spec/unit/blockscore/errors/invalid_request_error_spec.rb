module BlockScore
  RSpec.describe InvalidRequestError do
    subject { -> { BlockScore::Person.create(first_name: 'John') } }

    it_behaves_like 'an error'
  end
end
