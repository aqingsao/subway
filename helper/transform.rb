require File.expand_path(File.dirname(__FILE__), '../subway.rb')

input = 'original.txt'
output = '../subway.txt'

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
 		else
	 		if newLine
	 			newLine = false;
	 			@line = Line.new(str);
	 			subway.addLine @line
	 			puts "line name #{@line.name}"
	 		else
	 			stations = str.split("-").collect{|e|e.strip}
	 			stations.each do |s|
	 				@line.addStation(Station.new(subway.nextStationIndex(s), s))
	 			end
	 			puts "line station #{stations}"
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