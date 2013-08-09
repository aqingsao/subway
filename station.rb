class Station
	attr_reader :index, :name
	attr_accessor :transfer, :lines
	def initialize(index, name)
		@index, @name, @transfer, @lines = index, name, false, []
	end
	def ==(other)
		self.index == other.index && self.name == other.name
	end
end