require File.expand_path(File.join(__FILE__, '../test_helper'))

class UtilTest < Minitest::Test
  def test_underscore
    assert_equal BlockScore::Util.to_underscore('SuperBowl'), 'super_bowl'
    assert_equal BlockScore::Util.to_underscore('World'), 'world'
    assert_equal BlockScore::Util.to_underscore('foo_bar'), 'foo_bar'
    assert_equal BlockScore::Util.to_underscore(''), ''
    assert_equal BlockScore::Util.to_underscore('FooBarBaz'), 'foo_bar_baz'
  end

  def test_constant
    assert_equal BlockScore::Util.to_constant('BlockScore::Person'), BlockScore::Person
    assert_equal BlockScore::Util.to_constant('BlockScore::Company'), BlockScore::Company
    assert_equal BlockScore::Util.to_constant('BlockScore::QuestionSet'), BlockScore::QuestionSet
  end

  def test_plural
    assert_equal BlockScore::Util.to_plural('whale'), 'whales'
    assert_equal BlockScore::Util.to_plural('rock'), 'rocks'
    assert_equal BlockScore::Util.to_plural('test'), 'tests'
    assert_equal BlockScore::Util.to_plural('company'), 'companies'
    assert_equal BlockScore::Util.to_plural('person'), 'people'
    assert_equal BlockScore::Util.to_plural('beach'), 'beaches'
  end

  def test_camelcase
    assert_equal BlockScore::Util.to_camelcase('screaming_snake_case'), 'ScreamingSnakeCase'
    assert_equal BlockScore::Util.to_camelcase('snake_case'), 'SnakeCase'
    assert_equal BlockScore::Util.to_camelcase('foo'), 'Foo'
    assert_equal BlockScore::Util.to_camelcase(''), ''
  end
end
