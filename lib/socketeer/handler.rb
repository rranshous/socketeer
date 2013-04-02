require_relative 'selector_mix'
require_relative 'messenger'

class Handler

  # PUSHES : raw received data
  # PULLS  : raw to send data

  include Selectable
  include Messenger

  attr_reader :conn_id

  def initialize socket, conn_id
    @socket = socket
    @conn_id = conn_id
    register_monitor @socket, :r do |m|
      read
    end
  end

  def cycle
    cycle_data_in
    cycle_data_out
  end

  def cycle_data_in
    read
  end

  def cycle_data_out
    write pop_message
  end

  def socket
    @socket
  end

  def read
    begin
      # raises ex if no data to read
      data = ''
      loop do
        data << @socket.read_nonblock(4096)
      end
    rescue
      # no more datas
    end
    push_message data unless data.empty?
  end

  def write data
    return if data.nil?
    @socket.write data
  end

end
