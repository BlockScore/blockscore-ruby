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
    BlockScore::StubbedResponse::List.new(factory_name, options).response.fetch(:body)
  elsif action == 'history'
    BlockScore::StubbedResponse::History.new(factory_name).response.fetch(:body)
  else
    BlockScore::StubbedResponse::Retrieve.new(factory_name).response.fetch(:body)
  end
end

def build_test_response(status, body)
  { :status => status, :body => body, :headers => {} }
end