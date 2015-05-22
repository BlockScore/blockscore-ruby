# Test helpers to deal with query strings.

def parse_query(query)
  if query.nil?
    {}
  else
    query_options query
  end
end

def query_options(query)
  options = {}

  query.split('&').each do |pair|
    k, v = pair.split('=')
    options[k.to_sym] = v
  end

  options
end
