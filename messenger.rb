
module Messenger

  def bind_queues inqueue=nil, outqueue=nil
    @inqueue ||= inqueue
    @outqueue ||= outqueue
  end

  private

  def << message
    @outqueue << message unless @outqueue.nil?
  end

  def >>
    @inqueue.deq unless @inqueue.nil?
  end

end
