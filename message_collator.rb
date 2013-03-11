require_relative 'messenger'

class MessageCollator

  include Messenger

  def initialize deliminator
    @deliminator = deliminator
    @buffer = ''
  end

  def cycle
    handle_data_in pop
  end

  def handle_data_in data
    return if data.nil?
    @buffer += data
    return unless data.include? DELIM
    @buffer, *messages_data = @buffer.split DELIM
    messages_data.each do |message_data|
      push message_data
    end
  end

end
