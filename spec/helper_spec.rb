require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../helper/helper")

describe AmountGenerator do
	describe "next" do
		it "should generate random amount greater than 0" do
			amounts = 1000.times.each_with_object([]) do |i, amounts|
				amounts << AmountGenerator.next();
			end
			amounts.each do |amount|
				amount.should >= 0
			end
		end
	end
end

describe CardNoGenerator do
	describe "next" do
		it "should generate random card no with length 17" do
			cardNos = 100.times.each_with_object([]) do |i, cardNos|
				cardNos << CardNoGenerator.next();
			end
			cardNos.each do |cardNo|
				cardNo.length.should == 17
			end
		end
	end
end

describe DepartureTimeGenerator do
	before :each do
		@generator = DepartureTimeGenerator.new(5 * 60) if @generator.nil?
	end
	describe "next" do
		it "should generate random departure time" do
			times = 100.times.each_with_object([]) do |i, times|
				times << @generator.next();
			end
			times.sort.each do |t|
				p t
			end
		end
	end
end