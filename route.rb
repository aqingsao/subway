class LineStation
  attr_reader :line, :station
  def initialize(line, station)
    @line, @station = line, station
  end
end
class Route
  attr_reader :stations
  def initialize(stations, station_time=150, transfer_time=191)
    @stations, @station_time, @transfer_time = stations, station_time, transfer_time
    @line_stations = calculate_line_stations(stations)
  end
  def total_time
    (@line_stations.length - 1) * @station_time + (lines.length - 1) * @transfer_time
  end
  def lines
    @line_stations.collect{|line_station| line_station.line}.uniq
  end
  def ==(other)
    return false if @stations.length != other.stations.length
    @stations.each_with_index do |station, i|
      return false if station != other.stations[i]
    end
    return true
  end
  private
  def calculate_line_stations(stations)
    line_stations = []

    possible_lines = []
    previous_station = nil
    sliced_stations = []
    stations.each do |station|
      if possible_lines.empty?
	      sliced_stations << station
        possible_lines = station.lines.clone
      else
        if (possible_lines & station.lines) == []
          possible_line = possible_lines.first

          while(s = sliced_stations.shift)
          	line_stations << LineStation.new(possible_line, s)
          end
          sliced_stations = [station]
          possible_lines = station.lines & previous_station.lines
        else
  	      sliced_stations << station
          possible_lines &= station.lines
        end
      end
      previous_station = station
    end
    unless possible_lines.empty?
       sliced_stations.each {|s| line_stations << LineStation.new(possible_lines.first, s)}
    end
    # p "route: #{stations.collect{|station| station.name}}"
    # p "line: #{lines.collect{|line| line.name}}"
    line_stations
  end
end
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