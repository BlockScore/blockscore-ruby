module BlockScore
  class StubbedRequest
    def initialize(request)
      @request = request
      @uri     = request.uri
    end

    def factory_name
      resource.singularize
    end

    def resource
      path.fetch(1)
    end

    def id
      path.fetch(2, :no_id)
    end

    def action
      path.fetch(3, :no_action)
    end

    def path
      uri.path.split('/')
    end

    private

    attr_reader :request, :uri
  end
end