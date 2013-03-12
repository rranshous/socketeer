require_relative 'messenger'

class MessageCollator

  # PUSHES : full set of overall data (String)
  # PULLS  : pieces of overall data (String)

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
    puts "BUFFER: #{@buffer}"
    return unless data.include? @deliminator
    @buffer, *messages_data = @buffer.split @deliminator
    messages_data.each do |message_data|
      push message_data
    end
  end

end
