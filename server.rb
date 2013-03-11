require 'nio'
require 'socket'
require_relative 'selector_mix'
require_relative 'messenger'

class Server

  include Selectable
  include Messenger

  attr_accessor :host, :port

  def initialize host: 'localhost', port: 3123,
                 handler: nil

    @Handler = handler
    @host = host
    @port = port

    @connections = {}
    @tcp_server = TCPServer.new host, port
    register_monitor @tcp_server, :r do |monitor|
      handle_socket_connect @server.accept
    end
  end

  def cycle
    cycle_selector
    cycle_connection_queues
    cycle_inbound
  end

  private

  def cycle_inbound
    handle_new_message >>
  end

  def cycle_connection_queues
    @connections.each do |conn_id, (in_queue, out_queue)|
      handle_new_data conn_id, out_queue.deq(true)
    end
  end

  def handle_socket_connect socket
    create_handler socket
  end

  def create_handler socket
    conn_id = socket.id
    return unless @connections[conn_id].nil?
    # TODO: not ref Queue directly
    in_queue = Queue.new
    out_queue = Queue.new
    handler.new(socket).bind_queues data_in, data_queue
    @connections[conn_id] = [in_queue, out_queue]
  end

  def handler *args, **kwargs, &block
    @Handler.new @selector, *args, **kwargs, block
  end

  def handle_new_data conn_id, data
    return if data.nil?
    << :conn_id => conn_id, :data => data
  end

  def handle_new_message message
    return if message.nil?
    handler_in_queue
    @connections[message[:conn_id]][1] << :conn_id => message[:conn_id],
                                          :data => message[:data]
  end

end
