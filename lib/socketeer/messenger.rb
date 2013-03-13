require 'thread'

module Messenger

  attr_reader :in_queue, :out_queue

  def bind_queues in_queue=nil, out_queue=nil
    @in_queue ||= in_queue
    @out_queue ||= out_queue
  end

  private

  def push_message message
    return if message.nil?
    out_queue << message unless out_queue.nil?
  end

  def pop_message
    # noblock
    begin
      return in_queue.deq true unless in_queue.nil?
    rescue ThreadError
    end
    nil
  end

end
