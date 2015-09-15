module VCRHelper
  def self.spinlock_until(&_block)
    try_count = 0
    loop do
      try_count += 1
      break if try_count >= 30 || yield
      sleep 1
    end
  end
end
