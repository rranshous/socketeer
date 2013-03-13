
module Selectable

  def cycle_selector
    @selector.select(0.1) do |monitor|
      monitor.callback.call monitor
    end
  end

  private

  def register_monitor obj, mode, &callback
    monitor = selector.register obj, mode
    monitor.class.class_eval { attr_accessor :callback }
    monitor.callback = callback
    monitor
  end

  def selector
    @selector ||= NIO::Selector.new
  end
end
