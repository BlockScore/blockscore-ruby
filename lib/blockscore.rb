require 'delegate'
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
require 'blockscore/actions/write_once'

require 'blockscore/errors/api_connection_error'
require 'blockscore/errors/api_error'
require 'blockscore/errors/authentication_error'
require 'blockscore/errors/error'
require 'blockscore/errors/invalid_request_error'
require 'blockscore/errors/no_api_key_error'
require 'blockscore/errors/not_found_error'

require 'blockscore/version'

require 'blockscore/base'
require 'blockscore/candidate'
require 'blockscore/company'
require 'blockscore/person'
require 'blockscore/question_set'
require 'blockscore/watchlist_hit'

require 'blockscore/collection'
require 'blockscore/collection/member'
require 'blockscore/connection'
require 'blockscore/dispatch'
require 'blockscore/fingerprint'
require 'blockscore/response'
require 'blockscore/util'

module BlockScore
  class << self
    attr_accessor :api_key
  end
end
