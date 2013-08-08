# encoding: UTF-8
require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../graph")

describe Graph do
	before (:each) do
		@graph = Graph.new
		(1..6).each {|node| @graph.push node }
		@graph.connect_mutually 1, 2, 7
		@graph.connect_mutually 1, 3, 9
		@graph.connect_mutually 1, 6, 14
		@graph.connect_mutually 2, 3, 10
		@graph.connect_mutually 2, 4, 15
		@graph.connect_mutually 3, 4, 11
		@graph.connect_mutually 3, 6, 2
		@graph.connect_mutually 4, 5, 6
		@graph.connect_mutually 5, 6, 9
		 
		# p graph
		# p graph.length_between(2, 1)
		# p graph.neighbors(1)
		# p graph.route(1, 5)	
	end

	describe "route" do
		it	"should return [1] for route 1 to 1" do
			expect(@graph.route(1, 1)).to eq([1])
		end
		it	"should return [1,2] for route 1 to 2" do
			expect(@graph.route(1, 2)).to eq([1, 2])
		end
		it	"should return [1,3,4] for route 1 to 4" do
			expect(@graph.route(1, 4)).to eq([1, 3, 4])
		end
	end
end