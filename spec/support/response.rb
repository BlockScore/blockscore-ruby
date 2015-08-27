require 'cgi'

ERROR_IDS = %w(400 401 404 500)

def index_response(resource, count)
  {
    :total_count => count,
    :has_more => false,
    :object => 'list',
    :data => build_list(resource.to_sym, count)
  }.to_json
end

def error_id?(id)
  ERROR_IDS.include? id
end

def handle_test_response(stub)
  if error_id? stub.id
    handle_error_response stub.id
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


def handle_error_response(id)
  factory = error_factory_name(id)
  build_test_response(id.to_i, json(:blockscore_error, error_type: factory))
end

def error_factory_name(id)
  case id.to_i
  when 400
    'invalid_request_error'
  when 401
    'authentication_error'
  when 404
    'not_found_error'
  else
    'api_error'
  end
end
