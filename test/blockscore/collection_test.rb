require File.expand_path(File.join(__FILE__, '../../test_helper'))

class CollectionTest < Minitest::Test
  context 'a QuestionSet Collection' do
    setup do
      @collection = BlockScore::Collection.new(BlockScore::QuestionSet.new)
    end

    should 'collection should respond_to QuestionSet methods' do
      assert @collection.respond_to?(:create)
      assert @collection.respond_to?(:retrieve)
      assert @collection.respond_to?(:save)
      assert @collection.respond_to?(:score)
    end

    should 'collection should not catch and respond_to just any method' do
      refute @collection.respond_to?(:foo)
      refute @collection.respond_to?(:bar)
    end
  end
end
