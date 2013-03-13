require_relative 'messenger'

class MessageHandler

  # PUSHES : 
  # PULLS  : 

  include Messenger

  def initialize &handler
    @handler = handler
  end

  def cycle
    in_message = pop
    out_message = @handler.call in_message unless in_message.nil?
    push out_message
  end
end
