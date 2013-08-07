# encoding: UTF-8
require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../subway")

describe Subway do
	before (:each) do
		@station1 = Station.new(1, "s1")
		@line1 = Line.new("1号线", [@station1])
		@subway = Subway.new([@line1])
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

	describe "getStation" do
		it "should return nil when line does not contain a station" do
			expect(@subway.getStation("unknown station")).to be_nil
		end
		it "should return station when line does contain a station" do
			@subway.getStation("s1").should_not be_nil
			@subway.getStation("s1").name.should eq("s1")
		end
	end

	describe "addStation" do
		before :each do
			@station1 = Station.new(1, "s1")
			@line1 = Line.new("1号线", [@station1])
			@station2 = Station.new(2, "s2")
			@line2 = Line.new("2号线", [@station2])
			@subway = Subway.new([@line1, @line2])
		end

		it "add station to a line successfully" do
			station = Station.new(4, "s4")
			@subway.addStation(station, @line1)
			expect(@line1.containsStation(station.name)).to be_true
			expect(@line2.containsStation(station.name)).to be_false
		end
		it "will mark station as transformed if it's already contained in another line" do
			@subway.addStation(@station1, @line2)
			expect(@line2.containsStation(@station1.name)).to be_true
			expect(@station1.transformed).to be_true
		end
		it "will not mark station as transformed if it's contained in self line but not in other line" do
			@subway.addStation(@station2, @line2)
			expect(@line2.containsStation(@station2.name)).to be_true
			expect(@station2.transformed).to be_false
		end
	end

	describe 'calculateRoute' do
		before (:each) do
			@station1 = Station.new(1, "s1")
			@station2 = Station.new(2, "s2")
			@station3 = Station.new(3, "s3")
			@station11 = Station.new(11, "s11")
			@station12 = Station.new(12, "s12")
			@line1 = Line.new("1号线", [@station1, @station2, @station3])
			@line2 = Line.new("2号线", [@station11, @station12])
			@subway = Subway.new([@line1, @line2])
		end
		it	"should return route with empty edges when from station equals to station" do
			route = @subway.calculateRoute(@station1.index, @station1.index)
			expect(route.edges.length).to eq(0)
		end
		it	"should return route with 1 edge when from station sits next to to station" do
			route = @subway.calculateRoute(@station1.index, @station2.index)
			expect(route.edges.length).to eq(1)
			route.edges[0].should eq(Edge.new(@station1, @station2))
		end
	end
end