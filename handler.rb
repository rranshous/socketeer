require_relative 'selector_mix'
require_relative 'messenger'

class Handler

  # PUSHES : raw received data
  # PULLS  : raw to send data

  include Selectable
  include Messenger

  def initialize socket
    @socket = socket
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
    write pop
  end

  def socket
    @socket
  end

  def read
    begin
      # raises ex if no data to read
      data = @socket.read_nonblock 4096
      puts "HANDLER READ: #{data}"
      push data
    rescue
    end
  end

  def write data
    return if data.nil?
    puts "HANDLER WRITE: #{data}"
    @socket.write data
  end

end
