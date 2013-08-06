require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../subway")

describe Station do
	before (:each) do
		@station0 = Station.new(0, "s0")
		@station1 = Station.new(1, "s1")
	end
	describe 'eql?' do
		it 'return true when obj compares with itself' do
			expect(@station0.eql? @station0).to be_true
		end
		it 'return true when obj compares with other which has same name and index' do
			expect(@station0.eql? Station.new(0, "s0")).to be_true
		end
		it 'return false when obj compares with other which has different name or index' do
			expect(@station0.eql? @station1).to be_false
		end
	end
end
