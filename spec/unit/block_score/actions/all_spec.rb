require 'faker'

RSpec.describe BlockScore::Actions::All, vcr: true do
  describe '.all' do
    let(:uniq_token_one) { '4a2c019a1e3c33442644d9f52c7a93f7' }
    let(:uniq_token_two) { 'ba9a680671c6c006c6105aa450837668' }
    let!(:p1) { create(:person, name_first: 'John', name_last: uniq_token_one) }
    let!(:p2) { create(:person, name_first: 'John', name_last: uniq_token_two) }
    subject(:people) { BlockScore::Person.all }

    it { is_expected.not_to be_empty }
    it { expect(people[0].name_last).to eql uniq_token_two }
    it { expect(people[1].name_last).to eql uniq_token_one }

    context 'invalid filter parameter' do
      let(:expectation) do
        '(Type: invalid_request_error) ' \
        'Received unknown filter parameter: name_second (name_second) ' \
        '(Status: 400)'
      end
      it 'returns an error if filter parameter not in list' do
        expect { BlockScore::Person.all('filter[name_second]' => 'valid') }
          .to raise_error(BlockScore::InvalidRequestError, expectation)
      end
    end

    context 'invalid comparison operator' do
      let(:expectation) do
        '(Type: invalid_request_error) ' \
        'Received unknown filter directive: gtx (gtx) ' \
        '(Status: 400)'
      end
      it 'returns an error if comparison operator not in allowed list' do
        expect { BlockScore::Person.all('created_at[gtx]' => 1_455_660_769) }
          .to raise_error(BlockScore::InvalidRequestError, expectation)
      end
    end
  end

  describe '.included' do
    subject { object }
    let(:object) { described_class }
    let(:klass) { Class.new }

    it 'extends the klass' do
      expect(klass.singleton_class)
        .not_to include(described_class::ClassMethods)
      klass.send(:include, subject)
      expect(klass.singleton_class)
        .to include(described_class::ClassMethods)
    end
  end
end
