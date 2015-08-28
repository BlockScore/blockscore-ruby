module BlockScore
  RSpec.describe NotFoundError do
    subject(:retrieve) { -> { BlockScore::Person.retrieve('404') } }
    let(:message) do
      '(Type: not_found_error) Person with ID ab973197319713ba could not be found (Status: 404)'
    end

    it_behaves_like 'an error'
  end
end
