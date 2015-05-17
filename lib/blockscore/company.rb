require 'blockscore/actions/create'
require 'blockscore/actions/retrieve'
require 'blockscore/actions/all'

module BlockScore
  class Company < Base
    include BlockScore::Actions::Create
    include BlockScore::Actions::Retrieve
    include BlockScore::Actions::All
  end
end
