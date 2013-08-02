require File.join(File.dirname(__FILE__), 'user.rb')

user = User.new(1234567890)

user.visit(1, 15)
