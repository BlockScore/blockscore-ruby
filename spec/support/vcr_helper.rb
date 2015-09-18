module VCRHelper
  def self.spinlock_until(retries: 30)
    retries.times do
      return if yield
      sleep(1)
    end
  end
end
