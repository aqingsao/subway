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
  def transfer_stations
    previous_line = nil
    previous_station = nil
    @line_stations.each_with_object([]) do |line_station, stations|
      if !previous_line.nil? && line_station.line != previous_line
        previous_line = line_station.line
        stations << previous_station 
      end
      previous_line, previous_station = line_station.line, line_station.station
    end
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
    previous_stations = []
    stations.each do |station|
      if has_to_transfer(possible_lines, station.lines)
        previous_line = possible_lines.first
        possible_lines = station.lines & previous_stations.last.lines

        while(s = previous_stations.shift)
        	line_stations << LineStation.new(previous_line, s)
        end
        previous_stations = [station]
      else
	      previous_stations << station
        possible_lines = station.lines if possible_lines.empty?
        possible_lines &= station.lines unless possible_lines.empty?
      end
    end
    unless possible_lines.empty?
       previous_stations.each {|s| line_stations << LineStation.new(possible_lines.first, s)}
    end
    line_stations
  end
  def has_to_transfer(possible_lines, new_lines)
  	!possible_lines.empty? && ((possible_lines & new_lines) == [])
  end
end