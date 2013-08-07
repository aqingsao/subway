require File.join(File.dirname(__FILE__), 'user.rb')
require File.join(File.dirname(__FILE__), 'subway.rb')

def loadSubway(file)
	subway = Subway.new
	newLine = true;
	File.open(file, "r") do |file|  
	 	while str=file.gets
		 	str.strip!
	 		if(str.empty?)
	 			newLine = true;
	 		else
		 		if newLine
		 			newLine = false;
		 			@line = Line.new(str);
		 			subway.addLine @line
		 		else
		 			index, name = str.split(" ").collect{|e|e.strip}
		 			@line.addStation(Station.new(index.to_i, name))
		 		end
	 		end
	 	end 
	end  
	subway.afterBuild()
end

file = "subway.txt"
subway = loadSubway(file)
# puts "altogether there are #{subway.lines.length} lines"
# subway.lines.each do |line|
# 	puts "#{line.name}"
# 	line.stations.each do |station|
# 		puts "#{station.index}, #{station.name}"
# 	end
# 	puts "\n"
# end

p subway.graph
p subway.graph.length_between(2, 1)
p subway.graph.neighbors(1)
p subway.graph.dijkstra(1, 5)