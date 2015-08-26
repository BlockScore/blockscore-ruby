require File.expand_path(File.join(__FILE__, '../../test_helper'))

class CollectionTest < Minitest::Test
  def setup
    super()
    @collection = BlockScore::Collection.new(BlockScore::QuestionSet.new)
  end

  def test_valid_methods
    assert @collection.respond_to?(:create)
    assert @collection.respond_to?(:retrieve)
    assert @collection.respond_to?(:save)
    assert @collection.respond_to?(:score)
  end

  def test_invalid_methods
    refute @collection.respond_to?(:foo)
    refute @collection.respond_to?(:bar)
  end
end
