module BlockScore
  class Person < Base
    VALID   = 'valid'.freeze
    INVALID = 'invalid'.freeze

    include BlockScore::Actions::Create
    include BlockScore::Actions::Retrieve
    include BlockScore::Actions::All

    attr_reader :question_sets

    def initialize(options = {})
      super
      @question_sets = Collection.new({parent: self, target: QuestionSet })
    end

    def valid?
      status?(VALID)
    end

    def invalid?
      status?(INVALID)
    end

    private

    def status?(expected)
      status.eql?(expected)
    end
  end
end
