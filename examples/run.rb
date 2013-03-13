require 'socket'
require 'msgpack'
require_relative '../lib/socketeer'

Thread.abort_on_exception = true

#s = TCPSocket.new 'localhost', 2000
#s.write MessagePack.pack "test"
#s.write "\n\n"
#s.close

Thread.new do

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

end

sleep 3

Thread.new do 

  s1 = TCPSocket.new 'localhost', 2000
  s2 = TCPSocket.new 'localhost', 2001

  s2.write MessagePack.pack "Hello!"
  s2.write "\n\n"

  loop do
    begin
      in1 = s1.read_nonblock 1024
      puts "IN1: #{in1}"
      s2.write in1
    rescue
    end
    begin
      in2 = s2.read_nonblock 1024
      puts "IN2: #{in2}"
      s1.write in2
    rescue 
    end
  end

end

loop do
  sleep 1
end


