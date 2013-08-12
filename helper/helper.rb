class Gaussian
  def initialize(mean, stddev, rand_helper = lambda { Kernel.rand })
    @rand_helper = rand_helper
    @mean = mean
    @stddev = stddev
    @valid = false
    @next = 0
  end

  def rand
    if @valid then
      @valid = false
      return @next
    else
      @valid = true
      x, y = self.class.gaussian(@mean, @stddev, @rand_helper)
      @next = y
      return x
    end
  end

  private
  def self.gaussian(mean, stddev, rand)
    theta = 2 * Math::PI * rand.call
    rho = Math.sqrt(-2 * Math.log(1 - rand.call))
    scale = stddev * rho
    x = mean + scale * Math.cos(theta)
    y = mean + scale * Math.sin(theta)
    return x, y
  end
end

class AmountGenerator
  @@gaussian = Gaussian.new(0.0, 100.0)
  def AmountGenerator.next
    amount = @@gaussian.rand
    amount = amount < 0.0 ? -amount : amount
    (amount * 10).ceil()/10.0
  end
end

class CardNoGenerator
  @@firstIndex=0
  @@lastIndex = 0
  def CardNoGenerator.next
    @@firstIndex+=1
    if @@firstIndex >999
      @@firstIndex = 0 
      @@lastIndex += 1
    end
    @@lastIndex = 0 if @@lastIndex > 999
    sprintf("1%03d%05d%03d%05d", @@firstIndex,rand(100000), @@lastIndex, rand(100000))
  end
end

class DepartureTimeGenerator
  def initialize(mean_time_in_seconds)
    @mean_time_in_seconds = mean_time_in_seconds
    @gaussian = Gaussian.new(0.0, mean_time_in_seconds/2.5)
  end
  def next
    @gaussian.rand + @mean_time_in_seconds
  end
end