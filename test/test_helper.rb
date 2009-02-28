lib_dir = File.dirname(__FILE__) + '/../lib'
require 'test/unit'
$:.unshift lib_dir unless $:.include?(lib_dir)
require 'amazon'
require 'amazon/aws'
require 'amazon/aws/search'

include Amazon::AWS
include Amazon::AWS::Search


class Test::Unit::TestCase
  @@associates_id = "reagif-20"
  @@key_id = "15QN36861J5Q5KH0KZR2"
end