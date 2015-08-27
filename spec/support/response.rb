require 'cgi'

def index_response(resource, count)
  {
    :total_count => count,
    :has_more => false,
    :object => 'list',
    :data => build_list(resource.to_sym, count)
  }.to_json
end

def handle_test_response(stub)
  if BlockScore::StubbedResponse::Error::MAP.key?(stub.id)
    BlockScore::StubbedResponse::Error.new(stub.id).response
  else
    status = response_status stub.action, stub.http_method
    body = response_body stub.id, stub.action, stub.factory_name, stub.query_params, stub.http_method

    build_test_response status, body
  end
end

def response_status(action, http_method)
  if http_method == :post && action.nil?
    201
  else
    200
  end
end

def response_body(id, action, factory_name, options, http_method)
  if id.equal?(:no_id) && http_method == :get || action == 'hits'
    index_response factory_name, options.fetch('count', [5]).first.to_i
  elsif action == 'history'
    build_list(factory_name, 5).to_json
  else
    json(factory_name)
  end
end

def build_test_response(status, body)
  { :status => status, :body => body, :headers => {} }
end