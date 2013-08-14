# encoding: UTF-8
require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../graph")
require File.join(File.dirname(__FILE__), "../station")
require File.join(File.dirname(__FILE__), "../line")
require File.join(File.dirname(__FILE__), "../subway")

describe Graph do
	before (:each) do
		@station1 = Station.new(1, "s1")
		@station2 = Station.new(2, "s2")
		@station3 = Station.new(3, "s3")
		@station4 = Station.new(4, "s4")
		@line1 = Line.new("1号线", [@station1, @station2])
		@line2 = Line.new("2号线", [@station2, @station3])
		@line3 = Line.new("3号线", [@station1, @station4])
		@subway = Subway.new([@line1, @line2, @line3])
		@graph = Graph.new @subway
	end

	describe "route" do
		it	"should return [1] for route 1 to 1" do
			expect(@graph.route(@station1, @station1)).to eq(Route.new [@station1])
		end
		it	"should return [1,2] for route 1 to 2" do
			expect(@graph.route(@station1, @station2)).to eq(Route.new [@station1, @station2])
		end
		it	"should return [1,2,4] for route 1 to 3" do
			expect(@graph.route(@station1, @station3)).to eq(Route.new [@station1, @station2, @station3])
		end
		it	"should return [3, 2, 1, 4] for route 3 to 4" do
			expect(@graph.route(@station3, @station4)).to eq(Route.new [@station3, @station2, @station1, @station4])
		end
	end

	describe "routes" do
		it	"should return [1] for route 1 to 1" do
			@graph.routes.length.should == 12
		end
	end
	describe "max_transfer_times" do
		it "should return 2 for this subway" do
			expect(@graph.max_transfer_times).to be(2)
		end
	end
end