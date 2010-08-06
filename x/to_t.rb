require 'date'

class String
  # converts to DateTime by calling its #parse
  def to_t
    # I'm sorry there will be no spec...
    DateTime.parse(self)
  rescue
  end
end
