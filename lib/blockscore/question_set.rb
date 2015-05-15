module BlockScore
  class QuestionSet < Base

    def score(answers)
      self.class.post "#{self.class.endpoint}/#{id}/score", {}
    end

    def create
      self.class.create({ :person_id => instance_variable_get(:@attrs)[:person_id] })
    end

    private

    def self.create(params = {})
      super
    end
  end
end
