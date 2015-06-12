module BlockScore
  class Collection < Array
    def initialize(target)
      super()
      @target = target
    end

    def method_missing(method, *args, &block)
      @target.public_send(method, *args, &block)
    end
  end
end
