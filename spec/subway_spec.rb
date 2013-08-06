# encoding: UTF-8
require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../subway")

describe Subway do
	before (:each) do
		@station1 = Station.new(1, "s1")
		@line1 = Line.new("1号线", [Station.new(0, "s0"), @station1, Station.new(2, "s2"), Station.new(3, "s3")])
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

	describe "maxStationIndex" do
		it	"should return 0 when there are none stations" do
			expect(Subway.new.maxStationIndex).to eq(0)
		end
		it	"should return 1 when there is a station with index 1" do
			expect(Subway.new([Line.new("1号线", [Station.new(1, "s0")])]).maxStationIndex).to eq(1)
		end
		it	"should return 10 when there is 2 stations with index 1 and 10" do
			expect(Subway.new([Line.new("1号线", [Station.new(1, "s0")]), Line.new("2号线", [Station.new(10, "s10")])]).maxStationIndex).to eq(10)
		end
		it	"should return 0 when there are 2 emtpy lines" do
			expect(Subway.new([Line.new("1号线"), Line.new("2号线")]).maxStationIndex).to eq(0)
		end
	end

	describe "getStation" do
		it "should return nil when line does not contain a station" do
			expect(@subway.getStation("unknown station")).to be_nil
		end
		it "should return station when line does contain a station" do
			expect(@subway.getStation("s1")).to eq(@station1)
		end
	end
end