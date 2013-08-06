require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../subway")

describe Station do
	before (:each) do
		@station0 = Station.new(0, "s0")
		@station1 = Station.new(1, "s1")
	end
	describe '==' do
		it 'return true when obj compares with itself' do
			expect(@station0.== @station0).to be_true
		end
		it 'return true when obj compares with other which has same name and index' do
			expect(@station0.== Station.new(0, "s0")).to be_true
		end
		it 'return false when obj compares with other which has different name or index' do
			expect(@station0.== @station1).to be_false
		end
		it 'return true when a hash include object' do
			expect([@station0, @station1].include? Station.new(0, "s0")).to be_true
		end
	end

	describe "transformed" do
		it "should return false when a station is not a transform station" do
			expect(Station.new(0, "s0").transformed).to be_false
		end
		it "should return true when a station is set to betransformed" do
			station = Station.new(0, "s0")
			station.transformed=true
			expect(station.transformed).to be_true
		end
	end
end
