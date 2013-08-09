# encoding: UTF-8
require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../subway")

describe Subway do
	before (:each) do
		@station1 = Station.new(1, "s1")
		@line1 = Line.new("1号线", [@station1])
		@subway = Subway.new([@line1]).marshal()
	end

	describe "contains_station" do
		it	"should return true when subway contains a station" do
			expect(@subway.contains_station("s1")).to be_true
		end
		it	"should return false when subway does not contain a station" do
			expect(@subway.contains_station("unknown station")).to be_false
		end
	end

	describe "max_station_number" do
		it	"should return 0 when there are none stations" do
			expect(Subway.new.max_station_number).to eq(0)
		end
		it	"should return 1 when there is a station with number 1" do
			expect(Subway.new([Line.new("1号线", [Station.new(1, "s0")])]).max_station_number).to eq(1)
		end
		it	"should return 10 when there is 2 stations with number 1 and 10" do
			expect(Subway.new([Line.new("1号线", [Station.new(1, "s0")]), Line.new("2号线", [Station.new(10, "s10")])]).max_station_number).to eq(10)
		end
		it	"should return 0 when there are 2 emtpy lines" do
			expect(Subway.new([Line.new("1号线"), Line.new("2号线")]).max_station_number).to eq(0)
		end
	end

	describe "station_by_name" do
		it "should return nil when line does not contain a station" do
			expect(@subway.station_by_name("unknown station")).to be_nil
		end
		it "should return station when line does contain a station" do
			@subway.station_by_name("s1").should be(@station1)
		end
	end

	describe "stations" do
		it "should return all stations" do
			expect(@subway.stations.length).to eq(1)
		end
	end

end