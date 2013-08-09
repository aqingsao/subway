# encoding: UTF-8
require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../subway")

describe Subway do
	before (:each) do
		@station1 = Station.new(1, "s1")
		@line1 = Line.new("1号线", [@station1])
		@subway = Subway.new([@line1]).marshal()
	end

	describe "containsStation" do
		it	"should return true when subway contains a station" do
			expect(@subway.containsStation("s1")).to be_true
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

	describe "station_by_name" do
		it "should return nil when line does not contain a station" do
			expect(@subway.station_by_name("unknown station")).to be_nil
		end
		it "should return station when line does contain a station" do
			@subway.station_by_name("s1").should_not be_nil
			@subway.station_by_name("s1").name.should eq("s1")
		end
	end

	describe "stations" do
			before (:each) do
				@station1 = Station.new(1, "s1")
				@station2 = Station.new(2, "s2")
				@station3 = Station.new(3, "s3")
				@line1 = Line.new("1号线", [@station1])
				@subway = Subway.new([Line.new("1号线", [@station1, @station2]), Line.new("2号线", [@station1, @station3])])
			end

		it "should return all stations" do
			expect(@subway.stations.length).to eq(3)
		end
	end

end