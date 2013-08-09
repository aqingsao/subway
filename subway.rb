require File.join(File.dirname(__FILE__), 'graph.rb')
require File.join(File.dirname(__FILE__), 'line.rb')
require File.join(File.dirname(__FILE__), 'station.rb')

class Subway
	attr_reader :lines, :graph
	def initialize(lines = [])
		@lines = lines
	end
	def addLine(line)
		@lines.push line
	end
	def contains_station(station_name)
		@lines.any?{|line| line.stations.any? {|station| station.name == station_name}}
	end
	def station_by_name(station_name)
		@lines.each do |line|
			line.stations.each do |station|
				return station if station.name == station_name
			end
		end
		nil
	end
	def station_by_number(station_number)
		@lines.each do |line|
			line.stations.each do |station|
				return station if station.number == station_number
			end
		end
		nil
	end
	def line_by_name(line_name)
		@lines.find{|line| line.name == line_name}
	end
	def max_station_number
		result = @lines.collect{|line| line.max_station_number}.max
		result.nil? ? 0 : result
	end
	def stations
		@lines.each_with_object([]){|line, stations| line.stations.each{|s| stations<<s} }.uniq
	end

	def marshal
		self
	end
end
class SubwayHelper
  def SubwayHelper.load(file)
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
            number, name = str.split(" ").collect{|e|e.strip}
            @line.add_station(subway.contains_station(name) ? subway.station_by_name(name) : Station.new(number.to_i, name)) 
          end
        end
      end 
    end  
    subway.marshal()
  end
end