require_relative 'messenger'

class MessageHandler

  include Messenger

  def cycle
    m = pop
    puts "MessageHandler message: #{m}" unless m.nil?
    push m
  end
end
