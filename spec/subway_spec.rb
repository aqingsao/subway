# encoding: UTF-8
require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../subway")

describe Subway do
	before (:each) do
		@line1 = Line.new("1号线", [Station.new(0, "s0"), Station.new(1, "s1"), Station.new(2, "s2"), Station.new(3, "s3")])
		@line2 = Line.new("2号线", [Station.new(10, "s10"), Station.new(2, "s1"), Station.new(11, "s11")])
		@subway = Subway.new([@line1, @line2])
	end

	describe "containsStation" do
		it	"should return true when subway contains a station" do
			expect(@subway.containsStation("s0")).to be_true
		end
		it	"should return false when subway does not contain a station" do
			expect(@subway.containsStation("unknown station")).to be_false
		end
	end
end