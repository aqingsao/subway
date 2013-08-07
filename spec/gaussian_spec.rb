require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../helper/gaussian")

describe AmountGenerator do
	describe "next" do
		it "" do
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
		it "" do
			cardNos = 100.times.each_with_object([]) do |i, cardNos|
				cardNos << CardNoGenerator.next();
			end
			cardNos.each do |cardNo|
				p cardNo
				cardNo.length.should == 17
			end
		end
	end

end