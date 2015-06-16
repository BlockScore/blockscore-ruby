require File.expand_path(File.join(__FILE__, '../../test_helper'))

class UtilTest < Minitest::Test
  def test_underscore
    assert_equal 'super_bowl', BlockScore::Util.to_underscore('SuperBowl')
    assert_equal 'world', BlockScore::Util.to_underscore('World')
    assert_equal 'foo_bar', BlockScore::Util.to_underscore('foo_bar')
    assert_equal '', BlockScore::Util.to_underscore('')
    assert_equal 'foo_bar_baz', BlockScore::Util.to_underscore('FooBarBaz')
  end

  def test_constant
    assert_equal BlockScore::Person, BlockScore::Util.to_constant('BlockScore::Person')
    assert_equal BlockScore::Company, BlockScore::Util.to_constant('BlockScore::Company')
    assert_equal BlockScore::QuestionSet, BlockScore::Util.to_constant('BlockScore::QuestionSet')
  end

  def test_plural
    assert_equal 'candidates', BlockScore::Util.to_plural('candidate')
    assert_equal 'question_sets', BlockScore::Util.to_plural('question_set')
    assert_equal 'companies', BlockScore::Util.to_plural('company')
    assert_equal 'people', BlockScore::Util.to_plural('person')
    assert_equal 'watchlist_hits', BlockScore::Util.to_plural('watchlist_hit')
  end

  def test_camelcase
    assert_equal 'ScreamingSnakeCase', BlockScore::Util.to_camelcase('screaming_snake_case')
    assert_equal 'SnakeCase', BlockScore::Util.to_camelcase('snake_case')
    assert_equal 'Foo', BlockScore::Util.to_camelcase('foo')
    assert_equal '', BlockScore::Util.to_camelcase('')
  end

  def test_parse_json
    obj = { :foo => 'bar', :baz => 'bat' }
    assert_equal obj, BlockScore::Util.parse_json(obj.to_json)
  end

  def test_parse_json_error
    obj = { foo: 'bar', baz: 'bat' }
    raised = assert_raises BlockScore::Error do
      BlockScore::Util.parse_json(obj.to_json + '{}')
    end

    msg = 'An error has occurred. If this problem persists, please message support@blockscore.com.'
    assert_equal msg, raised.message
  end
end
