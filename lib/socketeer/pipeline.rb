require_relative 'messenger'

class Pipeline
  def initialize *messengers
    @messengers = messengers
  end
  def cycle
    @messengers.each_cons(2) do |a, b|
      a.cycle if a.respond_to? 'cycle'
      begin
        1000.times do 
          m = a.out_queue.deq true
          b.in_queue << m
        end
      rescue ThreadError
      end
    end
  end
end
