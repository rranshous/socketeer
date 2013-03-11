require 'msgpack'
require_relative 'server'
require_relative 'handler'
require_relative 'message_transformer'
require_relative 'message_collator'

server_out_queue = Queue.new
server_in_queue = Queue.new
in_message_transformer_in_queue = Queue.new
in_message_transformer_out_queue = Queue.new
out_message_transformer_in_queue = Queue.new
out_message_transformer_out_queue = Queue.new

server = Server.new 'localhost', 3123, Handler
collator = MessageCollator.new "\n\n"
in_message_transformer = MessageTransformer.new do |d|
  MessagePack.unpack d
end
out_message_transformer = MessageTransformer.new do |d|
  MessagePack.pack d
end

# server will push out of it's queue hashes
# containing the `conn_id` and the data it's received
# it will take any messages it receives and push the data
# down to handler who has the connection

# between the server out and the message transformer we
# need to collate messages, we will be receiving data
# piecemeal and need to wait until we have an entire message
# before we act.

server.bind_queue server_in_queue, server_out_queue
collator.bind server_out_queue, in_message_transformer_in_queue

# messages coming from the collator go into the message transformer
in_message_transformer.bind_queue in_message_transformer_in_queue, 
                                  in_message_transformer_out_queue

# once the messages have been transformed, they are ready to be handled
# and than the results to be fed back out
message_handler.bind_queue in_message_transformer_out_queue,
                           out_message_transformer_in_queue

# back through the transformer
# from the transformer back to the server
out_message_transformer.bind_queue out_message_transformer_in_queue,
                                   server_in_queue


