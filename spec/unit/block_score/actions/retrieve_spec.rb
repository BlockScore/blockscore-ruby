require 'faker'

RSpec.describe BlockScore::Actions::Retrieve, vcr: true do
  describe '.retrieve' do
    let(:person_id) { create(:person).id }
    subject(:person) { BlockScore::Person.retrieve(person_id) }

    it { is_expected.to be_persisted }
    its(:name_first) { is_expected.not_to be_empty }
    it { is_expected.to be_an_instance_of BlockScore::Person }

    it 'must supply an ID' do
      expect { BlockScore::Person.retrieve(nil) }
        .to raise_error(ArgumentError, 'ID must be supplied')
      expect { BlockScore::Person.retrieve('') }
        .to raise_error(ArgumentError, 'ID must be supplied')
    end

    context 'Malformed ID presented' do
      let(:person_id) { 'ABC&&234' }

      it 'must have a properly formed ID' do
        expect { BlockScore::Person.retrieve(person_id) }
          .to raise_error(ArgumentError, 'ID is malformed')
      end
    end
  end

  it_behaves_like 'included class methods'
end
