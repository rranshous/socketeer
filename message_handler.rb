require_relative 'messenger'

class MessageHandler

  # PUSHES : 
  # PULLS  : 

  include Messenger

  def cycle
    m = pop
    puts "MessageHandler message: #{m}" unless m.nil?
    push m
  end
end
