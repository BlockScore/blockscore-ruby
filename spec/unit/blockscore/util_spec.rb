require File.expand_path(File.join('spec/blockscore/util_test.rb', '../../spec_helper'))

module BlockScore
  RSpec.describe Util do
    it 'test_plural' do
      expect(BlockScore::Util.to_plural('candidate')).to eq('candidates')
      expect(BlockScore::Util.to_plural('question_set')).to eq('question_sets')
      expect(BlockScore::Util.to_plural('company')).to eq('companies')
      expect(BlockScore::Util.to_plural('person')).to eq('people')
      expect(BlockScore::Util.to_plural('watchlist_hit')).to eq('watchlist_hits')
    end

    it 'test_camelcase' do
      expect(BlockScore::Util.to_camelcase('screaming_snake_case')).to eq('ScreamingSnakeCase')
      expect(BlockScore::Util.to_camelcase('snake_case')).to eq('SnakeCase')
      expect(BlockScore::Util.to_camelcase('foo')).to eq('Foo')
      expect(BlockScore::Util.to_camelcase('')).to eq('')
    end

    it 'test_parse_json' do
      obj = { foo: 'bar', baz: 'bat' }
      expect(BlockScore::Util.parse_json(obj.to_json)).to eq(obj)
    end

    it 'test_parse_json_error' do
      obj = { foo: 'bar', baz: 'bat' }
      expect { BlockScore::Util.parse_json((obj.to_json + '{}')) }.to raise_error(BlockScore::Error) do |raised|
        msg = 'An error has occurred. If this problem persists, please message support@blockscore.com.'
        expect(raised.message).to eq(msg)
      end
    end
  end
end