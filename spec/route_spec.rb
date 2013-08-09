# encoding: UTF-8
require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../subway")
require File.join(File.dirname(__FILE__), "../helper/helper.rb")

describe Route do
	before (:each) do
		@subway = SubwayHelper.loadSubway(File.join(File.dirname(__FILE__), "subway_test.txt")) if @subway.nil?
	end

	describe "lines" do
		it	"should return line 1 from station 1 to 2" do
			# @subway.station_by_name
			# route = @subway.routes.route(1, 2)
			# route.should_not be_nil
			# route.lines.should == [@line1]
		end
	end
end