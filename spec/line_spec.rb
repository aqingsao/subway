# encoding: UTF-8
require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../subway")

describe Line do
	before (:each) do
		@station = Station.new(1, "s1")
		@line1 = Line.new("1号线", [@station])
	end

	describe "containsStation" do
		it	"should return true when subway contains a station" do
			expect(@line1.containsStation("s1")).to be_true
		end
		it	"should return false when subway does not contain a station" do
			expect(@line1.containsStation("unknown station")).to be_false
		end
	end

	describe "maxStationIndex" do
		it	"should return 0 when there are none stations" do
			expect(Line.new("1号线").maxStationIndex).to eq(0)
		end
		it	"should return 1 when there is a station with index 1" do
			expect(Line.new("1号线", [Station.new(1, "s1")]).maxStationIndex).to eq(1)
		end
		it	"should return 10 when there is 2 stations with index 1 and 10" do
			expect(Line.new("1号线", [Station.new(1, "s0"), Station.new(10, "s10")]).maxStationIndex).to eq(10)
		end
	end

	describe "getStation" do
		it "should return nil when line does not contain a station" do
			expect(@line1.getStation("unknown station")).to be_nil
		end
		it "should return station when line does contain a station" do
			expect(@line1.getStation("s1")).to eq(@station)
		end
	end

	describe "addStation" do
		before :each do
			@station1 = Station.new(1, "s1")
			@line1 = Line.new("1号线", [@station1])
			@station2 = Station.new(2, "s2")
			@line2 = Line.new("2号线", [@station2])
		end

		it "add station to a line successfully" do
			station = Station.new(4, "s4")
			@line1.addStation station
			expect(@line1.containsStation(station.name)).to be_true
		end
	end
end