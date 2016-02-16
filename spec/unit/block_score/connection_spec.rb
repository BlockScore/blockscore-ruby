require 'faker'

RSpec.describe BlockScore::Connection do
  before do
    BlockScore.api_key = ENV.fetch(BlockScore::ENVIRONMENT_API_KEY,
                                   BlockScore::PLACEHOLDER_API_KEY)
  end

  describe 'general' do
    subject(:company) { BlockScore::Company.create(attributes_for(:company)) }

    context 'no api key' do
      it 'provided no api key' do
        BlockScore.api_key = false
        expect { company }
          .to raise_error(BlockScore::NoAPIKeyError, 'No API key was provided.')
      end
    end

    context 'no socket' do
      it 'raises socketerror' do
        allow(BlockScore::Company)
          .to receive(:execute_request).and_raise(SocketError)
        expect { company }
          .to raise_error(BlockScore::APIConnectionError, 'SocketError')
      end

      it 'raises Errno::ECONNREFUSED' do
        allow(BlockScore::Company)
          .to receive(:execute_request).and_raise(Errno::ECONNREFUSED)
        expect { company }
          .to raise_error(BlockScore::APIConnectionError, 'Connection refused')
      end
    end

    context 'normal request' do
      it 'creates the company using :post' do
        expect(BlockScore::Company.create(attributes_for(:company)))
          .to be_an_instance_of(BlockScore::Company)
      end

      it 'retrieves no persons using :get' do
        expect(BlockScore::Person.all('filter[status]' => 'unknown'))
          .to be_empty
      end

      it 'retrieves the persons' do
        expect(BlockScore::Person.all('filter[name_middle]' => nil))
          .not_to be_empty
      end
    end
  end

  describe '#delete' do
    subject(:candidate) { create(:candidate) }
    before do
      candidate.delete
    end

    it { is_expected.not_to be_persisted }
    it { expect(candidate.deleted).to be true }
    it 'has the deleted attributes' do
      expect(BlockScore::Candidate.retrieve(candidate.id).deleted).to be true
    end
  end

  describe '#patch' do
    subject(:candidate) { create(:candidate, name_first: 'John') }
    before do
      expect(candidate.persisted?).to be true
      candidate.name_first = 'Janie'
      expect(candidate.save!).to be true

      candidate.name_first = 'Jane'
      expect(candidate.save!).to be true
    end

    it 'has the same attributes' do
      expect(BlockScore::Candidate
               .retrieve(candidate.id)
               .attributes.reject { |key, _| key.equal?(:updated_at) })
        .to eql candidate.attributes.reject { |key, _| key.equal?(:updated_at) }
    end
  end

  describe '#post' do
    subject(:candidate) { build(:candidate, name_first: 'John') }

    it 'has the same attributes' do
      candidate.save!

      refreshed_candidate = BlockScore::Candidate.retrieve(candidate.id)
      expect(refreshed_candidate.name_first).to eql 'John'
      expect(refreshed_candidate.attributes).to eql candidate.attributes
    end
  end
end
