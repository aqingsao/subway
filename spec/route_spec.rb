# encoding: UTF-8
require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../route")
require File.join(File.dirname(__FILE__), "../helper/helper.rb")

describe Route do
	# before (:each) do
	# 	@subway = SubwayHelper.loadSubway(File.join(File.dirname(__FILE__), "subway_test.txt")) if @subway.nil?
	# 	@scenarios = [
	# 		{from: "五棵松", to: "万寿路", lines:["1号线"]}, 
	# 		{from: "南礼士路", to: "阜成门", lines:["1号线", "2号线"]}, 
	# 		{from: "军事博物馆", to: "西直门", lines:["9号线", "4号线"]}
	# 	]
	# end

	# describe "lines" do
	# 	it	"should return expected lines when given from station and to station" do
	# 		@scenarios.each do |scenario|
	# 			from = @subway.station_by_name(scenario[from])
	# 			from.should_not be_nil
	# 			to = @subway.station_by_name(scenario[to])
	# 			to.should_not be_nil
				
	# 			route = @subway.routes.route(from.number, to.number)
	# 			route.should_not be_nil
	# 			route.lines.should == scenario[lines].collect{|line| @subway.line_by_name(line)}
	# 		end
	# 	end
	# end
end