require 'socket'
require 'msgpack'

s = TCPSocket.new 'localhost', 3123
s.write MessagePack.pack "test"
s.write "\n\n"
