RSpec.describe BlockScore::Util do
  shared_context 'a transform' do
    subject(:actual) { described_class.send(method, input) }
    it { should eql(output) }
  end

  describe '.to_plural' do
    shared_context 'to_plural' do
      let(:method) { :to_plural }
      include_context 'a transform'
    end

    context 'candidate' do
      let(:input) { 'candidate' }
      let(:output) { 'candidates' }

      it_behaves_like 'to_plural'
    end

    context 'question_set' do
      let(:input) { 'question_set' }
      let(:output) { 'question_sets' }

      it_behaves_like 'to_plural'
    end

    context 'company' do
      let(:input) { 'company' }
      let(:output) { 'companies' }

      it_behaves_like 'to_plural'
    end

    context 'person' do
      let(:input) { 'person' }
      let(:output) { 'people' }

      it_behaves_like 'to_plural'
    end

    context 'watchlist_hit' do
      let(:input) { 'watchlist_hit' }
      let(:output) { 'watchlist_hits' }

      it_behaves_like 'to_plural'
    end
  end

  describe '.to_camelcase' do
    shared_context 'to_camelcase' do
      let(:method) { :to_camelcase }
      include_context 'a transform'
    end

    context 'screaming_snake_case' do
      let(:input) { 'screaming_snake_case' }
      let(:output) { 'ScreamingSnakeCase' }

      it_behaves_like 'to_camelcase'
    end

    context 'snake_case' do
      let(:input) { 'snake_case' }
      let(:output) { 'SnakeCase' }

      it_behaves_like 'to_camelcase'
    end

    context 'foo' do
      let(:input) { 'foo' }
      let(:output) { 'Foo' }

      it_behaves_like 'to_camelcase'
    end

    context 'empty string' do
      let(:input) { '' }
      let(:output) { '' }

      it_behaves_like 'to_camelcase'
    end
  end

  describe '.parse_json' do
    shared_context 'parse_json' do
      let(:method) { :parse_json }
      include_context 'a transform'
    end

    context 'valid input' do
      let(:input) { output.to_json }
      let(:output) { { foo: 'bar', baz: 'bat' } }

      it_behaves_like 'parse_json'
    end

    context 'translates errors' do
      let(:error) do
        'An error has occurred. ' \
          'If this problem persists, please message support@blockscore.com.'
      end
      let(:input) { '{{' }
      subject(:parse_attempt) { described_class.parse_json(input) }

      it 'raises an error when the json fails to parse' do
        expect { subject }.to raise_error do |err|
          expect(err).to be_an_instance_of(BlockScore::Error)
          expect(err.message).to eql(error)
        end
      end
    end
  end
end
