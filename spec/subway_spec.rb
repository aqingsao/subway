require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../subway")

describe Subway do
	before (:each) do
		@line1 = Line.new([Station.new(0, "s0"), Station.new(1, "s1"), Station.new(2, "s2"), Station.new(3, "s3")])
		@line2 = Line.new([Station.new(10, "s10"), Station.new(2, "s1"), Station.new(11, "s11")])
		@subway = Subway.new([@line1, @line2])
	end

	describe "route" do
		it	"" do
			route = @subway.route(0, 1)
			# expect(route.lines.length).to eq(1)
		end
	end
end

describe Edge do
	before (:each) do
		@station0 = Station.new(0, "s0")
		@station1 = Station.new(1, "s1")
		@station2 = Station.new(2, "s2")

		@edge0 = Edge.new(@station0, @station1)
		@edge1 = Edge.new(@station1, @station2)

		@edge2 = Edge.new(@station0, @station1)
	end
	describe 'equals' do
		it '' do
			class Edge
			  def all_equals(o)
			    ops = [:==, :===, :eql?, :equal?]
			    puts "all_equals #{o}"
			    Hash[ops.map(&:to_s).zip(ops.map {|s| puts send(s, o) })]
			  end
			end
			@edge0.all_equals @edge0
			@edge0.all_equals @edge1
			@edge0.all_equals @edge2
		end
	end
end