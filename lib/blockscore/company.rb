module BlockScore
  class Company < Base
    include BlockScore::Actions::Create
    include BlockScore::Actions::Retrieve
    include BlockScore::Actions::WriteOnce
    include BlockScore::Actions::All
  end
end
