class Station
	attr_reader :index, :name
	attr_accessor :lines
	def initialize(index, name)
		@index, @name, @lines = index, name, []
	end
	def ==(other)
		self.index == other.index && self.name == other.name
	end
end