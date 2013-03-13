require_relative 'socketeer'

class Randomizer
  include Socketeer
  def handle_message message
    message[:data] += Random.rand.to_s
    message
  end
end

rander = Randomizer.new
rander.bind 'localhost', 2000

echoer = Class.new.class_eval do
  include Socketeer
end.new

echoer.bind 'localhost', 2001 do |m|
  m
end

while loop
  rander.cycle
  echoer.cycle
end
