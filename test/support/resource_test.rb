require 'blockscore/util'

module ResourceTest
  def resource
    @resource ||= BlockScore::Util.to_underscore(to_s[/^(\w+)ResourceTest/, 1])
  end

  def test_create_resource
    response = create(:"#{resource}_params")
    assert_equal response.class, resource_to_class(resource)
    assert_requested(@api_stub, times: 1)
  end

  def test_retrieve_resource
    r = build(resource)
    response = resource_to_class(resource).send(:retrieve, r.id)

    assert_equal resource, response.object
    assert_requested(@api_stub, times: 1)
  end

  def test_list_resource
    resource_to_class(resource).send(:all)

    assert_requested(@api_stub, times: 1)
  end

  def test_list_resource_with_count
    response = resource_to_class(resource).send(:all, {count: 2})

    assert_equal 2, response.count
    assert_requested(@api_stub, times: 1)
  end

  def test_list_resource_with_count_and_offset
    response = resource_to_class(resource).
      send(:all, {count: 2, offset: 2})

    assert_equal 2, response.count
    assert_requested(@api_stub, times: 1)
  end

  def test_init_and_save
    params = build(resource).attributes
    obj = resource_to_class(resource).new

    params.each do |key, value|
      obj.public_send "#{key.to_s}=".to_sym, value
    end

    assert obj.save
    assert_requested(@api_stub, times: 1)
  end
end
