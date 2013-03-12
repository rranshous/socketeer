require 'msgpack'
require_relative 'server'
require_relative 'handler'
require_relative 'message_transformer'
require_relative 'message_collator'
require_relative 'message_handler'
require_relative 'passthrough'
require_relative 'pipeline'

message_handler = MessageHandler.new
server = Server.new host: 'localhost', port: 3123, handler: Handler
collator = MessageCollator.new "\n\n"
in_message_transformer = MessageTransformer.new {|d| MessagePack.unpack d }
out_message_transformer = MessageTransformer.new {|d| MessagePack.pack d }
server.bind_queues Queue.new, Queue.new
collator.bind_queues Queue.new, Queue.new
in_message_transformer.bind_queues Queue.new, Queue.new
out_message_transformer.bind_queues Queue.new, Queue.new
message_handler.bind_queues Queue.new, Queue.new



# server will push out of it's queue hashes
# containing the `conn_id` and the data it's received
# it will take any messages it receives and push the data
# down to handler who has the connection


# between the server out and the message transformer we
# need to collate messages, we will be receiving data
# piecemeal and need to wait until we have an entire message
# before we act.

# messages coming from the collator go into the message transformer

# once the messages have been transformed, they are ready to be handled
# and than the results to be fed back out

# back through the transformer
# from the transformer back to the server

pipeline = Pipeline.new(server, 
                        Passthrough.new(:data, collator),
                        Passthrough.new(:data, in_message_transformer),
                        message_handler, 
                        Passthrough.new(:data, out_message_transformer),
                        server)

loop do 
  pipeline.cycle
  sleep(2)
end
