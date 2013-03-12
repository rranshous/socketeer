require 'nio'
require 'socket'
require_relative 'selector_mix'
require_relative 'messenger'

class Server

  # PUSHES : {:conn_id, :data}
  # PULLS  : {:conn_id, :data}

  include Selectable
  include Messenger

  attr_accessor :host, :port

  def initialize(host: 'localhost', port: 3123, handler: nil)

    @Handler = handler
    @host = host
    @port = port

    @connections = {}
    puts "BINDING: #{host}:#{port}"
    @tcp_server = TCPServer.new host, port
    register_monitor @tcp_server, :r do |monitor|
      handle_socket_connect @tcp_server.accept
    end
  end

  def cycle
    cycle_selector
    cycle_connection_queues
    cycle_inbound
    cycle_handlers
  end

  private

  def cycle_handlers
    @connections.each {|conn_id, handler| handler.cycle}
  end

  def cycle_inbound
    handle_new_message pop
  end

  def cycle_connection_queues
    @connections.each do |conn_id, handler|
      begin
        handle_new_data conn_id, handler.out_queue.deq(true)
      rescue ThreadError
      end
    end
  end

  def handle_socket_connect socket
    create_handler socket
  end

  def create_handler socket
    conn_id = socket.object_id
    return unless @connections[conn_id].nil?
    # TODO: not ref Queue directly
    h = handler(socket)
    h.bind_queues Queue.new, Queue.new
    @connections[conn_id] = h
  end

  def handler socket
    @Handler.new socket
  end

  def handle_new_data conn_id, data
    return if data.nil?
    push :conn_id => conn_id, :data => data
  end

  def handle_new_message message
    return if message.nil?
    @connections[message[:conn_id]].in_queue << message[:data]
  end

end
