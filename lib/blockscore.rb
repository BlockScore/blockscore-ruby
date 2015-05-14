require "httparty"

Dir[File.dirname(__FILE__) + '/blockscore/*.rb'].each do |file|
  require file
end

module BlockScore  
  def self.api_key(api_key)
    Base.auth api_key
  end

  def self.version(v)
    Base.version = v
  end
end
