require_relative 'messenger'

class Passthrough

  include Messenger

  def initialize attr, messenger
    @attr = attr
    @messenger = messenger
    bind_queues Queue.new, Queue.new
  end

  def cycle
    in_flight = []
    begin
      in_message = in_queue.deq true 
      puts "INMESSAGE: #{in_message}"
      if in_message 
        in_flight << in_message
        puts "PUT DATA [#{@attr}]: #{in_message[@attr]}"
        @messenger.in_queue << in_message[@attr]
      end
    rescue ThreadError
    end
    begin
      out_message = @messenger.out_queue.deq true
      if out_message
        original_message = in_flight.shift
        puts "ORIGINALMESSAGE: #{original_message}"
        original_message[@attr] = out_message
      end
    rescue ThreadError
    end
    @messenger.cycle if @messenger.respond_to? 'cycle'
  end
end
