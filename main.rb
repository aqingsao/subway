require File.join(File.dirname(__FILE__), 'user.rb')
require File.join(File.dirname(__FILE__), 'subway.rb')
require File.join(File.dirname(__FILE__), 'helper/gaussian.rb')

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

userCount = 1000
factory = UserFactory.new subway
users = factory.nonTransfered((userCount * 0.1).ceil)

startTime = Time.new
while(not (remaining = users.find_all{|user| !user.finished}).empty?)
	remaining.each do |user|
		user.enter if user.readyToEnter(startTime)
		user.leave if user.readyToLeave(startTime)
	end
	sleep 1
end