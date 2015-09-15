module BlockScore
  RSpec.shared_context 'api request' do
    let(:base_url)    { "https://#{Spec::API_KEY}:@api.blockscore.com"   }
    let(:url)         { base_url + uri                                   }
    let(:_expected)   { respond_to?(:expected) ? expected : { body: {} } }
    subject(:request) { a_request(http_method, url).with(_expected)      }

    it { should have_been_made }
  end

  %w(get post patch delete).each do |verb|
    RSpec.shared_context verb.upcase do
      let(:http_method) { verb.to_sym }

      include_context 'api request'
    end
  end
end
