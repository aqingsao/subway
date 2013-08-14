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
	describe 'mean_time' do
		it 'mean time should be 0 when given 1 user' do
			expect(DepartureTimeGenerator.new(1).mean_time).to eq(0)
		end
		it 'mean time should be about 10 minutes when given 100 user' do
			expect(DepartureTimeGenerator.new(100).mean_time).to be_within(10).of(600)
		end
		it 'mean time should be about 20 minutes when given 10,000 user' do
			expect(DepartureTimeGenerator.new(10000).mean_time).to be_within(10).of(1200)
		end
		it 'mean time should be about 25 minutes when given 100,000 user' do
			expect(DepartureTimeGenerator.new(100000).mean_time).to be_within(10).of(1500)
		end
		it 'mean time should be about 30 minutes when given 1,000,000 user' do
			expect(DepartureTimeGenerator.new(1000000).mean_time).to be_within(10).of(1800)
		end
	end
	describe "next" do
		it "departure time should be 0 from now when given 1 user" do
			generator = DepartureTimeGenerator.new(1)
			100.times.each() do |i|
				expect(generator.next()).to eq(0)
			end
		end
		it "average departure time should be about 10 minutes from now when given 100 user" do
			generator = DepartureTimeGenerator.new(100)
			count = 100
			sum = count.times.inject do |sum, i|
				sum = sum + generator.next
			end
			expect(sum/100.0).to be_within(60).of(600)
		end
		it "average departure time should be about 30 minutes from now when given 1,000,000 user" do
			generator = DepartureTimeGenerator.new(1000000)
			count = 100
			sum = count.times.inject do |sum, i|
				sum = sum + generator.next
			end
			expect(sum/100.0).to be_within(180).of(1800)
		end
	end
end