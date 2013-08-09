# encoding: UTF-8
require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../route")
require File.join(File.dirname(__FILE__), "../station")
require File.join(File.dirname(__FILE__), "../line")
require File.join(File.dirname(__FILE__), "../subway")
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
	before (:each) do
		@station1 = Station.new(1, "s1")
		@station2 = Station.new(2, "s2")
		@station3 = Station.new(3, "s3")
		@station4 = Station.new(4, "s4")
		@line1 = Line.new("1号线", [@station1, @station2])
		@line2 = Line.new("2号线", [@station2, @station3])
		@line3 = Line.new("3号线", [@station1, @station4])
	end

	describe "lines" do
		it"should return line1 when given 1 station" do
			route = Route.new([@station1])
			expect(route.lines.length).to eq(1)
			expect(route.lines[0]).to eq(@line1)
		end
		it"should return line1 when given from station 1 to station 2" do
			route = Route.new([@station1, @station2])
			expect(route.lines.length).to eq(1)
			expect(route.lines[0]).to eq(@line1)
		end
		it"should return line1 and line2 when given from station 1 to station 2" do
			route = Route.new([@station1, @station3])
			expect(route.lines.length).to eq(2)
			expect(route.lines[0]).to eq(@line1)
			expect(route.lines[1]).to eq(@line2)
		end
		it"should return line2 and line1 and line3 when given from station 3 to station 4" do			
			route = Route.new([@station3, @station2, @station1, @station4])
			expect(route.lines.length).to eq(3)
			expect(route.lines[0]).to eq(@line2)
			expect(route.lines[1]).to eq(@line1)
			expect(route.lines[2]).to eq(@line3)
		end
	end
	describe "total_time" do
		it "should return 0 when given 1 station" do
			route = Route.new([@station1])
			expect(route.total_time).to eq(0)
		end
		it "should return 5.0 when given from station 1 to station 2" do
			route = Route.new([@station1, @station2], 2.5)
			expect(route.total_time).to eq(2.5)
		end
	end

end