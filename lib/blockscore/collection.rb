module BlockScore
  class Collection < Array
    def initialize(target)
      super()
      @target = target
    end

    def respond_to?(method, include_all = false)
      @target.respond_to?(method, include_all)
    end

    private

    def method_missing(method, *args, &block)
      @target.public_send(method, *args, &block)
    end
  end
end
