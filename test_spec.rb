require 'socket'

s = TCPSocket.new 'localhost', 3123
s.write "test\n\n"
