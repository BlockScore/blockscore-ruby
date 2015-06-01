require 'blockscore/fingerprint'
require 'blockscore/util'
require 'forwardable'

module BlockScore
  class Dispatch
    extend Forwardable

    def_delegators :@fingerprint, :builder, :data, :resource

    def initialize(resource, response)
      @fingerprint = BlockScore::Fingerprint.new(resource, response.body)
    end

    def call
      Util.send(builder, resource, data)
    end

    private

    def builder
      resource_array? ? :create_array : :create_object
    end

    # array formatted response
    def resource_array?
      data.is_a? Array
    end
  end
end
