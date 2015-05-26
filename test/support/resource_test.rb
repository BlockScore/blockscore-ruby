require 'blockscore/util'

module ResourceTest
  def self.included(base)
    base.mattr_accessor :resource
    base.resource = BlockScore::Util.to_underscore(base.to_s[/^(\w+)ResourceTest/, 1])
  end

  def test_create_resource
    response = create_resource(resource)
    assert_equal response.class, resource_to_class(resource)
  end

  def test_retrieve_resource
    r = create_resource(resource)
    response = resource_to_class(resource).send(:retrieve, r.id)
    assert_equal resource, response.object
  end

  def test_list_resource
    response = resource_to_class(resource).send(:all)
    assert_equal Array, response.class
  end

  def test_list_resource_with_count
    msg = "List #{resource} with count = 2 failed"
    response = resource_to_class(resource).send(:all, {:count => 2})
    assert_equal Array, response.class, msg
  end

  def test_list_resource_with_count_and_offset
    msg = "List #{resource} with count = 2 and offset = 2 failed"
    response = resource_to_class(resource).
      send(:all, {:count => 2, :offset => 2})
    assert_equal Array, response.class, msg
  end
end
