require_relative 'messenger'

class Pipeline
  def initialize *messengers
    @messengers = messengers
  end
  def cycle
    puts "PIPE CYCLE"
    @messengers.each_cons(2) do |a, b|
      a.cycle if a.respond_to? 'cycle'
      begin
        m = a.out_queue.deq true
        puts "#{a} => #{b} == #{m}"
        b.in_queue << m
      rescue ThreadError
      end
    end
  end
end
