module BlockScore
  class FakeResource < BlockScore::Base
    include BlockScore::Actions::All
    include BlockScore::Actions::Create
    include BlockScore::Actions::Delete
    include BlockScore::Actions::Retrieve
    include BlockScore::Actions::Update

    def self.resource
      'fake_resource'
    end

    def self.endpoint
      'https://api.blockscore.com/fake_resources'
    end
  end
end
