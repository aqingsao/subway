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
		# p graph.dijkstra(1, 5)	
	end

	describe "dijkstra" do
		it	"should return 7 when vertext 1 and 2 is connected by 7" do
			@graph.dijkstra(1, 4)
			# expect(@graph.dijkstra(1, 2)).to eq(7)
		end
	end
end