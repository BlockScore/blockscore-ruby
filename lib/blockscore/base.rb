require 'net/http'
require 'uri'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/string/inflections'
require 'blockscore/connection'

module BlockScore
  class Base
    include BlockScore::Connection
    
    mattr_accessor :api_key, :resource, :version
    version = 4

    def self.inherited(base)       
      # i.e. for BlockScore::Verification, we want 'verification'
      base.resource = base.to_s.split('::').last.underscore
    end

    def self.auth(api_key)
      api_key = api_key
      BlockScore::Connection.api_key = api_key
    end

    def self.create(params = {})
      response = BlockScore::Connection.post(endpoint, params)

      #begin
      #  result = @error_handler.check_error(response)
      #rescue BlockScore::BlockScoreError => e
      #  raise
      #end
    end

    def self.retrieve(id)
      options = { :basic_auth => { :username => api_key, :password => "" } }

      response = get("#{endpoint}/#{id}", {})

      begin
        result = @error_handler.check_error(response)
      rescue BlockScore::BlockScoreError => e
        raise
      end
    end

    def self.all(options = {})
    end

    def self.api_url
      'https://api.blockscore.com/'
    end

    def self.endpoint
      "#{api_url}#{resource.pluralize}/"
    end
  end
end
