require 'socket'
require 'msgpack'

#s = TCPSocket.new 'localhost', 2000
#s.write MessagePack.pack "test"
#s.write "\n\n"
#s.close

s1 = TCPSocket.new 'localhost', 2000
s2 = TCPSocket.new 'localhost', 2001

s1.write MessagePack.pack "Hello!"
s1.write "\n\n"

loop do
  begin
    in1 = s1.read_noblock 1024
    puts "IN1: #{in1}"
    s2.write in1
  rescue
  end
  begin
    in2 = s2.read_noblock 1024
    puts "IN2: #{in2}"
    s1.write in2
  rescue 
  end
  sleep 1
end
