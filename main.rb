require File.join(File.dirname(__FILE__), 'user.rb')
require File.join(File.dirname(__FILE__), 'subway.rb')

file = "subway.txt"

subway = Subway.new()
File.open(file, 'r') do |file|

end

puts "altogether there are #{subway.lines.length} lines"
subway.lines.each do |line|
	puts "#{line.name}"
	line.stations.each do |station|
		puts "#{station.index}, #{station.name}"
	end
end