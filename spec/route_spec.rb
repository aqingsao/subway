# encoding: UTF-8
require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../subway")

describe Route do
	before (:each) do
		@station1 = Station.new(1, "s1")
		@station2 = Station.new(2, "s2")
		@station3 = Station.new(3, "s3")
		@line1 = Line.new("1号线", [@station1, @station2])
		@line2 = Line.new("1号线", [@station1, @station3])
		@subway = Subway.new([@line1, @line2]).marshal()
	end

	describe "lines" do
		it	"should return line 1 from station 1 to 2" do
			route = @subway.routes.route(1, 2)
			route.should_not be_nil
			route.lines.should == [@line1]
		end
		it	"should return line 1 and line 2 from station 1 to 3" do
			route = @subway.routes.route(1, 3)
			p @subway.routes.simple_routes
			route.should_not be_nil
			route.lines.should == [@line1, @line2]
		end
	end
end