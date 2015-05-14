require 'test_helper'
require 'active_support'
require 'active_support/core_ext'

RESOURCES = %w(candidate company person question_set)

RESOURCES.each do |r|
  eval <<-reval
    class #{r.capitalize}ResourceTest < ActiveSupport::TestCase
      test "create a #{r}" do
        response = TestClient.create_#{r}
        assert_equal 201, response.code
      end

      test "retrieve a #{r}" do
        #{r}_id = TestClient.create_#{r}[:id]
        response = TestClient.client.#{r.pluralize}.retrieve(#{r}_id)
        assert_equal 200, response.code
      end

      test "list #{r.pluralize}" do
        # CHANGE THIS
        response = TestClient.client.#{r.pluralize}.all(count=25)
        assert_equal 200, response.code
      end

      test "list count=2 #{r.pluralize}" do
        response = TestClient.client.#{r.pluralize}.all(count = 2)
        assert_equal 200, response.code
      end

      test "list count=2 offset=2 #{r.pluralize}" do
        response = TestClient.client.#{r.pluralize}.all(count = 2, offset = 2)
        assert_equal 200, response.code
      end
    end
  reval
end
