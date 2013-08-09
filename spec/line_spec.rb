# encoding: UTF-8
require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../line")

describe Line do
	before (:each) do
		@station = Station.new(1, "s1")
		@line1 = Line.new("1号线", [@station])
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

	describe "station_by_name" do
		it "should return nil when line does not contain a station" do
			expect(@line1.station_by_name("unknown station")).to be_nil
		end
		it "should return station when line does contain a station" do
			expect(@line1.station_by_name("s1")).to eq(@station)
		end
	end

	describe "add_station" do
		before :each do
			@station1 = Station.new(1, "s1")
			@line1 = Line.new("1号线", [@station1])
			@station2 = Station.new(2, "s2")
			@line2 = Line.new("2号线", [@station2])
		end

		it "add station to a line successfully" do
			station = Station.new(4, "s4")
			@line1.add_station station
			expect(@line1.stations.include? station).to be_true
		end
	end

	describe "transferableLines" do
		it "return empty when a line is not transferable to any other lines" do
			 Line.new("1号线").transferableLines.should be_empty
		end
		it "return 1 line when a line is transferable to another line" do
			station1 = Station.new(1, "s1")
			station2 = Station.new(2, "s2")
			station3 = Station.new(3, "s3")
			line1 = Line.new("1号线", [station1, station2])
			line2 = Line.new("2号线", [station2, station3])
			subway = Subway.new([line1, line2]).marshal()
			
			expect(line1.transferableLines.length).to eq(1)
			line1.transferableLines[0].should eq(line2)
		end
		it "return 2 lines when a line is transferable to another 2 lines" do
			station1 = Station.new(1, "s1")
			station2 = Station.new(2, "s2")
			station3 = Station.new(3, "s3")
			station4 = Station.new(4, "s4")
			line1 = Line.new("1号线", [station1, station2])
			line2 = Line.new("2号线", [station2, station3])
			line3 = Line.new("3号线", [station1, station4])
			subway = Subway.new([line1, line2, line3]).marshal()
			
			expect(line1.transferableLines.length).to eq(2)
			expect(line1.transferableLines.include? line2).to be_true
			expect(line1.transferableLines.include? line3).to be_true
		end
	end
end