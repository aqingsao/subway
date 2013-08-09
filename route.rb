# class Route
# 	attr_reader :stations, :lines
# 	def initialize(stations = [])
# 		@stations = stations
# 		@lines = calculate_lines()
# 	end
# 	def ==(other)
# 		return false unless self.stations.length == other.stations.length
# 		result = true;
# 		self.stations.each_with_index do |e, i|
# 			result = false unless (e == other.stations[i])
# 		end
# 		result
# 	end
# 	private 
# 	def calculate_lines
# 		lines = []
# 		currentLine = []
# 		stations.each do |station|
# 			if currentLine.empty?
# 				currentLine = station.lines
# 			else
# 				if (currentLine & station.lines) == []
# 					lines << currentLine.shift
# 					currentLine = station.lines
# 				else
# 					currentLine &= station.lines
# 				end
# 			end
# 		end
# 		lines << currentLine.first unless currentLine.empty?
# 		# p "route: #{stations.collect{|station| station.name}}"
# 		# p "line: #{lines.collect{|line| line.name}}"

# 		lines
# 	end
# end

# class Routes < Array
# 	def simple_routes
# 		self.collect{|route| route.stations.collect{|station| station.number}}
# 	end
# 	def routes_with_transfer(times)
# 		self.find_all{|route| route.lines.length == times + 1}
# 	end

# 	def route(src, dst)
# 		self.find do |route|
# 			return route if (route.stations.first.number == src && route.stations.last.number == dst)
# 		end
# 	end
# end