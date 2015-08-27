require File.expand_path(File.join('spec/blockscore/util_test.rb', '../../spec_helper'))

module BlockScore
  RSpec.describe Util do
    it '.to_plural' do
      expect(described_class.to_plural('candidate')).to eq('candidates')
      expect(described_class.to_plural('question_set')).to eq('question_sets')
      expect(described_class.to_plural('company')).to eq('companies')
      expect(described_class.to_plural('person')).to eq('people')
      expect(described_class.to_plural('watchlist_hit')).to eq('watchlist_hits')
    end

    it '.to_camelcase' do
      expect(described_class.to_camelcase('screaming_snake_case')).to eq('ScreamingSnakeCase')
      expect(described_class.to_camelcase('snake_case')).to eq('SnakeCase')
      expect(described_class.to_camelcase('foo')).to eq('Foo')
      expect(described_class.to_camelcase('')).to eq('')
    end

    describe '.parse_json' do
      it do
        obj = { foo: 'bar', baz: 'bat' }
        expect(described_class.parse_json(obj.to_json)).to eq(obj)
      end

      it 'raises error' do
        obj = { foo: 'bar', baz: 'bat' }
        expect { described_class.parse_json((obj.to_json + '{}')) }.to raise_error(BlockScore::Error) do |raised|
          msg = 'An error has occurred. If this problem persists, please message support@blockscore.com.'
          expect(raised.message).to eq(msg)
        end
      end
    end
  end
end