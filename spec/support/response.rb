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

def resource_from_uri(uri)
  uri.to_s.split('/').last.singularize.to_sym
end

# Make sure the stubbed URI is valid.
def check_uri_for_api_key(uri)
  unless uri.user
    fail ArgumentError, "URI doesn't include an API key"
  end
end

def error_id?(id)
  ERROR_IDS.include? id
end

def handle_test_response(request, id, action, factory_name)
  if error_id? id
    handle_error_response id
  else
    status = response_status request, action
    body = response_body request, id, action, factory_name

    build_test_response status, body
  end
end

def response_status(request, action)
  if request.method == :post && action.nil?
    201
  else
    200
  end
end

def response_body(request, id, action, factory_name)
  if id.equal?(:no_id) && request.method == :get || action == 'hits'
    options = parse_query request.uri.query
    index_response factory_name, options.fetch('count', [5]).first.to_i
  elsif action == 'history'
    build_list(factory_name, 5).to_json
  else
    json(factory_name)
  end
end

def parse_query(query)
  if query
    CGI::parse query
  else
    {}
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
