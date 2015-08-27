require File.expand_path(File.join('spec/blockscore/request_test.rb', '../../spec_helper'))

module BlockScore
  RSpec.describe NoAPIKeyError do
    it do
      without_authentication
      expect { create(:person_params).save }.to raise_error(described_class) do |raised|
        expect(raised.message).to eq('No API key was provided.')
      end
      with_authentication
    end
  end

  RSpec.describe NotFoundError do
    it do
      with_authentication
      expect { BlockScore::Person.retrieve('404') }.to raise_error(described_class) do |raised|
        expect(raised.error_type).to eq('not_found_error')
        expect(raised.http_status).to eq(404)
        msg = '(Type: not_found_error) Person with ID ab973197319713ba could not be found (Status: 404)'
        expect(raised.message).to eq(msg)
      end
    end
  end

  RSpec.describe InvalidRequestError do
    it do
      expect { BlockScore::Person.retrieve('400') }.to raise_error(described_class) do |raised|
        expect(raised.error_type).to eq('invalid_request_error')
        expect(raised.http_status).to eq(400)
        msg = '(Type: invalid_request_error) One of more parameters is invalid. (name_first) (Status: 400)'
        expect(raised.message).to eq(msg)
      end
    end
  end

  RSpec.describe APIError do
    it do
      with_authentication
      expect { BlockScore::Person.retrieve('500') }.to raise_error(described_class) do |raised|
        expect(raised.error_type).to eq('api_error')
        expect(raised.http_status).to eq(500)
        msg = '(Type: api_error) An error occurred. (Status: 500)'
        expect(raised.message).to eq(msg)
      end
    end
  end

  RSpec.describe AuthenticationError do
    it do
      expect { BlockScore::Person.retrieve('401') }.to raise_error(described_class) do |raised|
        expect(raised.error_type).to eq('authentication_error')
        expect(raised.http_status).to eq(401)
        msg = '(Type: authentication_error) The provided API key is invalid. (Status: 401)'
        expect(raised.message).to eq(msg)
      end
    end
  end

  RSpec.describe APIConnectionError do
    it do
      stub_request(:get, /.*api\.blockscore\.com\/people\/socket_error/).to_raise(SocketError)
      expect { BlockScore::Person.retrieve('socket_error') }.to raise_error(described_class) do |raised|
        expect(raised.message).to eq('Exception from WebMock')
      end
    end
  end

  RSpec.describe APIConnectionError do
    it 'connection_refused' do
      stub_request(:get, /.*api\.blockscore\.com\/people\/connection_refused/).to_raise(Errno::ECONNREFUSED)
      expect { BlockScore::Person.retrieve('connection_refused') }.to raise_error(described_class) do |raised|
        expect(raised.message).to eq('Connection refused - Exception from WebMock')
      end
    end
  end

  RSpec.describe Connection do
    it 'instantiation_does_not_request' do
      BlockScore::Person.new
      assert_not_requested(@api_stub)
    end

    it 'instantiation_with_hash_does_not_request' do
      create(:person)
      assert_not_requested(@api_stub)
    end

    it 'setting_attribute_does_not_request' do
      candidate = BlockScore::Candidate.new
      candidate.name_first = 'John'
      assert_not_requested(@api_stub)
    end
  end
end