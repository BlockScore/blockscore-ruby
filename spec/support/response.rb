def error_response?(stub)
  BlockScore::StubbedResponse::Error::MAP.key?(stub.id)
end

def create_response?(stub)
  stub.http_method == :post && stub.action.nil?
end

def list_response?(stub)
  stub.id.equal?(:no_id) && stub.http_method == :get || stub.action == 'hits'
end

def history_response?(stub)
  stub.action == 'history'
end

def handle_test_response(stub)
  if error_response?(stub)
    BlockScore::StubbedResponse::Error.new(stub.id).response
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
  elsif history_response?(stub)
    BlockScore::StubbedResponse::History.new(stub.factory_name).response.fetch(:body)
  else
    BlockScore::StubbedResponse::Retrieve.new(stub.factory_name).response.fetch(:body)
  end
end

def build_test_response(status, body)
  { :status => status, :body => body, :headers => {} }
end