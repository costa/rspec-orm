

class Object
  def recurse!(&b); end
end


class Array
  def recurse!(&b)
    map! { |e| e.recurse!(&b) || yield(e) }
  end
end


class Hash
  def recurse!(&b)
    each { |k,v| store(k, v.recurse!(&b) || yield(v)) }
  end
end
