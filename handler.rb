require_relative 'selector_mix'
require_relative 'messenger'

class Handler

  include Selectable
  include Messenger

  def initialize socket
    @socket = socket
    register_monitor @socket, :r {|m| read }
  end

  def cycle
    cycle_data_in
  end

  def cycle_data_in
    write >>
  end

  def socket
    @socket
  end

  def read
    data = @socket.read_nonblock 4096
    << data unless data.nil?
  end

  def write data
    return if data.nil?
    @socket.write_nonblock data
  end

end
