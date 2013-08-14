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
  attr_reader :mean_time
  def initialize(user_count)
    @mean_time = Math.log(user_count) * 130
    @gaussian = Gaussian.new(0.0, mean_time/2.5)
  end

  def next
    time = @gaussian.rand + @mean_time
    time < 0 ? 0 : time
  end
end

class PortionByTransferGenerator
  def PortionByTransferGenerator.portions(transfer_count, user_count)
    gaussian = Gaussian.new(1.8, 1.0)

    user_count.times.each_with_object((transfer_count+1).times.each_with_object([]){|i, portions| portions[i]=0}) do |i, portions|
      r = gaussian.rand.ceil
      r = 0 if r < 0
      r = transfer_count if r>transfer_count
      portions[r] += 1
    end
  end
end