require_relative 'messenger'

class MessageTransformer

  include Messenger

  def initialize transformer
    @transformer = transformer
  end

  def cycle
    handle_data_in >>
  end

  def handle_data_in data
    << transform data
  end

  private

  def transform data
    @transform.call data
  end

end
