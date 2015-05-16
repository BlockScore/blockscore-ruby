module BlockScore
  class Candidate < BlockScore::Base
    def delete
      self.class.delete "#{self.class.endpoint}/#{id}", {}
    end
    
    def history
      self.class.get "#{self.class.endpoint}/#{id}/history", {}
    end
    
    def hits
      self.class.get "#{self.class.endpoint}/#{id}/hits", {}
    end
  end
end
