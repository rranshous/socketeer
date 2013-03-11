require_relative 'messenger'

class MessageCollator

  include Messenger

  def initialize deliminator
    @deliminator = deliminator
    @buffer = ''
  end

  def cycle
    handle_data_in >>
  end

  def handle_data_in data
    return if data.nil?
    @buffer += data
    next unless data.include? DELIM
    @buffer, *messages_data = @buffer.split DELIM
    messages_data.each do |message_data|
      << transform_incoming message_data
    end
  end

end
