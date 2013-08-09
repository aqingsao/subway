require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../station")

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
end
