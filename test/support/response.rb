require File.expand_path(File.join(File.dirname(__FILE__), '../support/query'))

def index_response(resource, count)
  {
    :total_count => count,
    :has_more => false,
    :object => 'list',
    :data => FactoryGirl.build_list(resource.to_sym, count)
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

def handle_test_response(request, id, action, factory_name)
  status = response_status request, action
  body = response_body request, id, action, factory_name

  build_test_response status, body
end

def response_status(request, action)
  if request.method == :post && action.nil?
    201
  else
    200
  end
end

def response_body(request, id, action, factory_name)
  if id.nil? && request.method == :get || action == 'hits'
    options = parse_query request.uri.query
    index_response factory_name, options.fetch(:count, 5).to_i
  elsif action == 'history'
    FactoryGirl.build_list(factory_name, 5).to_json
  else
    FactoryGirl.json(factory_name)
  end
end

def build_test_response(status, body)
  { :status => status, :body => body, :headers => {} }
end
