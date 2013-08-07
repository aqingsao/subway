require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../subway")

describe Edge do
	before (:each) do
		@station0 = Station.new(0, "s0")
		@station1 = Station.new(1, "s1")
		@station2 = Station.new(2, "s2")

		@edge0 = Edge.new(@station0, @station1)
		@edge1 = Edge.new(@station1, @station2)
	end
	describe '==' do
		it 'should return true when edge compares with itself' do
			expect(@edge0 == @edge0).to be_true
		end
		it 'should return true when from and to stations are same' do
			expect(@edge0 == Edge.new(@station0, @station1)).to be_true
		end
		it 'should return false when from and to stations are inversed' do
			expect(@edge0 == Edge.new(@station1, @station0)).to be_false
		end
		it 'should return false when edge compares with other which has different stations' do
			expect(@edge0 == @edge1).to be_false
		end
	end
end