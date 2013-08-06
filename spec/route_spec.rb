require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../subway")

describe Route do
	before (:each) do
		@station0 = Station.new(0, "s0")
		@station1 = Station.new(1, "s1")
		@station2 = Station.new(2, "s2")

		@edge0 = Edge.new(@station0, @station1)
		@edge1 = Edge.new(@station1, @station2)
	end
	describe '==' do
		it 'route should equal to itself' do
			route = Route.new([@edge0, @edge1])
			expect(route == route).to be_true
		end
		it 'should return true when routes have same edges' do
			route1 = Route.new([@edge0, @edge1])
			route2 = Route.new([@edge0, @edge1])
			expect(Route.new == Route.new).to be_true
		end
		it 'should return false when routes have same edges and different orders' do
			route1 = Route.new([@edge0, @edge1])
			route2 = Route.new([@edge1, @edge0])
			expect(route1 == route2).to be_false
		end
		it 'should return false when edge compares with other which has different stations' do
			route1 = Route.new([@edge0, @edge1])
			route2 = Route.new([@edge0])
			expect(route1 == route2).to be_false
		end
	end
end