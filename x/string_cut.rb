
class String
  def cut(*idx)
    h, ret = 0, []
    idx.map do |i|
      ret << slice(h...i)
      h = i
    end
    ret << slice(h..-1)
  end
end
