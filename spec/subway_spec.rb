require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../subway")

describe Subway do
	before (:each) do
		@line1 = Line.new([Station.new(0, "s0"), Station.new(1, "s1"), Station.new(2, "s2"), Station.new(3, "s3")])
		@line2 = Line.new([Station.new(10, "s10"), Station.new(2, "s1"), Station.new(11, "s11")])
		@subway = Subway.new([@line1, @line2])
	end

	describe "route" do
		it	"" do
			expect(@subway.lines.length).to eq(2)
		end
	end
end