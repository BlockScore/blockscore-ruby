
def error_response?(stub)
  BlockScore::StubbedResponse::Error::MAP.key?(stub.id)
end

def create_response?(stub)
  stub.http_method == :post && !stub.has?(:action)
end

def delete_response?(stub)
  stub.http_method.equal?(:delete) && !stub.has?(:action)
end

def list_response?(stub)
  !stub.has?(:id) && stub.http_method == :get
end

def hits_response?(stub)
  stub.action == 'hits'
end

def history_response?(stub)
  stub.action == 'history'
end

def score_response?(stub)
  stub.action.eql?('score')
end

def update_response?(stub)
  stub.http_method.equal?(:patch)
end

def retrieve_response?(stub)
  stub.id && stub.http_method == :get
end

def handle_test_response(stub)
  if error_response?(stub)
    BlockScore::StubbedResponse::Router.call(stub).response
  else
    status = response_status(stub)
    body = response_body(stub)

    build_test_response status, body
  end
end

def response_status(stub)
  if create_response?(stub)
    201
  else
    200
  end
end

def response_body(stub)
  if list_response?(stub)
    BlockScore::StubbedResponse::List.new(stub.factory_name, stub.query_params).response.fetch(:body)
  elsif hits_response?(stub)
      BlockScore::StubbedResponse::List.new(stub.factory_name, stub.query_params).response.fetch(:body)
  elsif history_response?(stub)
    BlockScore::StubbedResponse::History.new(stub.factory_name).response.fetch(:body)
  elsif create_response?(stub)
    BlockScore::StubbedResponse::Retrieve.new(stub.factory_name).response.fetch(:body)
  elsif retrieve_response?(stub)
    BlockScore::StubbedResponse::Retrieve.new(stub.factory_name).response.fetch(:body)
  elsif delete_response?(stub)
    BlockScore::StubbedResponse::Retrieve.new(stub.factory_name).response.fetch(:body)
  elsif score_response?(stub)
    BlockScore::StubbedResponse::Retrieve.new(stub.factory_name).response.fetch(:body)
  elsif update_response?(stub)
    BlockScore::StubbedResponse::Retrieve.new(stub.factory_name).response.fetch(:body)
  else
    fail ArgumentError, "I don't know how to route this type of resource: #{stub.inspect}"
  end
end

def build_test_response(status, body)
  { :status => status, :body => body, :headers => {} }
end