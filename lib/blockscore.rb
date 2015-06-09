require 'forwardable'
require 'httparty'
require 'json'
require 'ostruct'
require 'uri'

require 'blockscore/actions/all'
require 'blockscore/actions/create'
require 'blockscore/actions/delete'
require 'blockscore/actions/retrieve'
require 'blockscore/actions/update'
require 'blockscore/base'
require 'blockscore/candidate'
require 'blockscore/company'
require 'blockscore/connection'
require 'blockscore/dispatch'
require 'blockscore/errors/api_connection_error'
require 'blockscore/errors/api_error'
require 'blockscore/errors/authentication_error'
require 'blockscore/errors/error'
require 'blockscore/errors/invalid_request_error'
require 'blockscore/fingerprint'
require 'blockscore/person'
require 'blockscore/question_set'
require 'blockscore/response'
require 'blockscore/util'
require 'blockscore/version'
require 'blockscore/watchlist_hit'

module BlockScore
  def self.api_key=(api_key)
    @api_key = api_key
  end

  def self.api_key
    @api_key
  end
end
