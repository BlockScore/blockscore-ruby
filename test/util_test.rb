require File.expand_path(File.join(__FILE__, '../test_helper'))

class UtilTest < Minitest::Test
  def test_underscore
    assert_equal BlockScore::Util.to_underscore('SuperBowl'), 'super_bowl'
    assert_equal BlockScore::Util.to_underscore('World'), 'world'
    assert_equal BlockScore::Util.to_underscore('foo_bar'), 'foo_bar'
    assert_equal BlockScore::Util.to_underscore(''), ''
    assert_equal BlockScore::Util.to_underscore('FooBarBaz'), 'foo_bar_baz'
  end
end
