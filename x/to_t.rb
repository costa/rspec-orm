require 'date'

# I'm sorry there will be no spec...
class String
  # converts to DateTime by calling its #parse
  def to_t
    DateTime.parse(self)
  rescue
  end
end
