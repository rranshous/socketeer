require_relative 'messenger'

class Passthrough

  include Messenger

  def initialize attr, messenger
    @attr = attr
    @messenger = messenger
    @in_flight = []
    bind_queues Queue.new, Queue.new
  end

  def cycle
    cycle_in_queue
    cycle_out_queue
    cycle_messenger
  end

  def cycle_in_queue
    begin
      in_message = in_queue.deq true 
      if in_message 
        @in_flight << in_message
        @messenger.in_queue << in_message[@attr]
      end
    rescue ThreadError
    end
  end

  def cycle_out_queue
    begin
      out_message = @messenger.out_queue.deq true
      if out_message
        original_message = @in_flight.shift
        puts "ORIGINALMESSAGE: #{original_message}"
        original_message[@attr] = out_message
        out_queue << original_message
      end
    rescue ThreadError
    end
  end

  def cycle_messenger
    @messenger.cycle if @messenger.respond_to? 'cycle'
  end
end
