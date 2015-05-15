require "httparty"

require 'blockscore/base'
require 'blockscore/candidate'
require 'blockscore/company'
require 'blockscore/person'

module BlockScore  
  def self.api_key(api_key)
    Base.auth api_key
  end

  def self.version(v)
    Base.version = v
  end
end
