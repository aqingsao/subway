require File.join(File.dirname(__FILE__), "spec_helper")
require File.join(File.dirname(__FILE__), "../helper/gaussian")
require File.join(File.dirname(__FILE__), "../helper/util")

describe Util do
	describe "cardNo" do
		it 'generate a random cardNo' do
			cardNo = Utils.cardNo
			puts cardNo
		end
	end
end