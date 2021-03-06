require_relative 'messenger'

class MessageTransformer

  # PUSHES : transformed data (objs)
  # PULLS  : raw data (String)

  include Messenger

  def initialize &transformer
    @transformer = transformer
  end

  def cycle
    handle_data_in pop_message
  end

  def handle_data_in data
    return if data.nil?
    push_message transform data
  end

  private

  def transform data
    @transformer.call data
  end

end
