require "httparty"

Dir[File.dirname(__FILE__) + '/blockscore/*.rb'].each do |file|
	require file
end