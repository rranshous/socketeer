require 'msgpack'
require_relative 'server'
require_relative 'handler'
require_relative 'message_transformer'
require_relative 'message_collator'
require_relative 'message_handler'
require_relative 'passthrough'
require_relative 'pipeline'

module Socketeer

  def bind host, port, &callback
    # will use the passed callback if provided, else calls handle_message
    callback ||= proc { |m| handle_message m }
    @message_handler = MessageHandler.new &callback 
    @server = Server.new host: host, port: port, handler: Handler
    @collator = MessageCollator.new "\n\n"
    @in_message_transformer = MessageTransformer.new {|d| MessagePack.unpack d }
    @out_message_transformer = MessageTransformer.new { |d|
      MessagePack.pack(d) + "\n\n"
    }
    @server.bind_queues Queue.new, Queue.new
    @collator.bind_queues Queue.new, Queue.new
    @in_message_transformer.bind_queues Queue.new, Queue.new
    @out_message_transformer.bind_queues Queue.new, Queue.new
    @message_handler.bind_queues Queue.new, Queue.new
    @pipeline = Pipeline.new(@server, 
                             Passthrough.new(:data, @collator),
                             Passthrough.new(:data, @in_message_transformer),
                             @message_handler, 
                             Passthrough.new(:data, @out_message_transformer),
                             @server)
  end

  def cycle
    @pipeline.cycle
  end

  private

  def handle_message message
  end

end
