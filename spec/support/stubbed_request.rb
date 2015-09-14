module BlockScore
  class StubbedRequest
    def initialize(request)
      @request = request
      @uri     = request.uri
    end

    def body
      JSON.parse(request.body)
    rescue
      nil
    end

    def factory_name
      resource.singularize
    end

    def resource
      path.fetch(1)
    end

    def has?(attribute)
      !public_send(attribute).equal?(:none)
    end

    def id
      path.fetch(2, :none)
    end

    def action
      path.fetch(3, :none)
    end

    def path
      uri.path.split('/')
    end

    def query_params
      CGI.parse(query)
    end

    def http_method
      request.method
    end

    private

    def query
      uri.query || ''
    end

    attr_reader :request, :uri
  end
end
