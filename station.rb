class Station
	attr_reader :number, :name
	attr_accessor :lines
	def initialize(number, name)
		@number, @name, @lines = number, name, []
	end
	def ==(other)
		self.number == other.number && self.name == other.name
	end
end