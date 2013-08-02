input = 'original.txt'
output = 'subway.txt'

INDEX = 0;

class Subway
	attr_reader :lines
	def initialize()
		@lines = []
		@stationIndex = 0
	end
	def addLine(line)
		@lines.push line
	end
	def nextStation(stationName)
		Station.new(getStationIndex(stationName), stationName)
	end
	private
	def getStationIndex(stationName)
		station = getStationByName(stationName)
		station ==nil ? @stationIndex+=1 : station.index
	end
	def getStationByName(stationName)
		line = @lines.detect{|line| line.contains(stationName)}
		line.getStationByName(stationName) unless line.nil?
	end
end
class Line
	attr_reader :name, :stations
	def initialize(name)
		@name = name;
		@stations = []
	end
	def addStation(station)
		@stations.push station
	end
	def getStationByName(stationName)
		@stations.detect {|station| station.name == stationName}
	end
	def contains(stationName)
		@stations.any?{|station| station.name == stationName}
	end
end
class Station
	attr_reader :index, :name
	def initialize(index, name)
		@index, @name = index, name
	end
end

def parseStation(station)
	station.split("-").collect{|e|e.strip}
end

subway = Subway.new
newLine = true;
File.open(input, "r") do |file|  
 	while str=file.gets
	 	str.strip!
 		if(str.empty?)
 			newLine = true;
	 		puts "\n"
 		else
	 		if newLine
	 			newLine = false;
	 			@line = Line.new(str);
	 			subway.addLine @line
	 			# puts "line name #{@line.name}"
	 		else
	 			stations = str.split("-").collect{|e|e.strip}
	 			stations.each do |s|
	 				@line.addStation(subway.nextStation(s))
	 			end
	 			# puts "line station #{stations}"
	 		end
 		end
 	end 
end  

File.open(output, "w") do |file|  
	subway.lines.each do |line|
		file.puts line.name
		line.stations.each do |s|
			file.puts "#{s.index} #{s.name}"
		end
		file.puts "\n"
	end
end  