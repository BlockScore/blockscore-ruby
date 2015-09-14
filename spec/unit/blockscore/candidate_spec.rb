module BlockScore
  RSpec.describe Candidate do
    let(:api_stub) { @api_stub }

    let(:candidate) { create(:candidate_params) }

    context 'updating' do
      before do
        candidate.name_first = 'Chris'
        candidate.save
      end

      let(:uri)         { "/candidates/#{candidate.id}"                     }
      let(:http_method) { :patch                                            }
      let(:expected)    { { body: hash_including('name_first' => 'Chris') } }

      it { expect(candidate.name_first).to eql('Chris') }
      include_context 'api request'
    end

    describe '#delete' do
      before { candidate.delete }

      let(:uri)         { "/candidates/#{candidate.id}" }
      let(:http_method) { :delete                       }

      include_context 'api request'
    end

    describe '#search' do
      let(:constraints) { { name_first: 'John' } }
      subject(:search) { -> { candidate.search(constraints) } }

      context 'search request' do
        let(:uri)      { '/watchlists'                                         }
        let(:body)     { { 'candidate_id' => candidate.id }.merge(constraints) }
        let(:expected) { { body: hash_including(body) }                        }
        before { search.call }

        include_context 'POST'
      end

      it { should_not change { constraints } }
    end
  end
end
