
module Selectable

  def cycle_selector
    @selector.select do |hot_monitor|
      monitor.callback.call hot_monitor
    end
  end

  private

  def register_monitor obj, mode, &callback
    monitor = selector.register socket, mode
    monitor.callback = callback
    monitor
  end

  def selector
    @selector ||= NIO::Selector.new
  end
end
