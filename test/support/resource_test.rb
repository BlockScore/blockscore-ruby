require 'blockscore/util'

module ResourceTest
  def resource
    @resource ||= BlockScore::Util.to_underscore(to_s[/^(\w+)ResourceTest/, 1])
  end

  def resource_class
    name = "BlockScore::#{BlockScore::Util.to_camelcase(resource.to_s)}"
    BlockScore::Util.to_constant(name)
  end

  def test_create_resource
    create(:"#{resource}_params")
    assert_requested(@api_stub, times: 1)
  end

  def test_retrieve_resource
    r = build(resource)

    assert_equal resource, resource_class.retrieve(r.id).object
    assert_requested(@api_stub, times: 1)
  end

  def test_list_resource
    resource_class.all

    assert_requested(@api_stub, times: 1)
  end

  def test_list_resource_with_count
    response = resource_class.all(count: 2)

    assert_equal 2, response.count
    assert_requested(@api_stub, times: 1)
  end

  def test_list_resource_with_count_and_offset
    response = resource_class.all(count: 2, offset: 2)

    assert_equal 2, response.count
    assert_requested(@api_stub, times: 1)
  end

  def test_init_and_save
    params = build(resource).attributes
    obj = resource_class.new

    params.each do |key, value|
      obj.public_send "#{key.to_s}=".to_sym, value
    end

    assert obj.save
    assert_requested(@api_stub, times: 1)
  end
end
