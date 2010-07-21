# new-save-reload protocol expected from the wrapped class (both AR & DM)
class PenetratingOrmWrapper  # FIXME? suggest a better silly name, what? :-)

  attr_reader :saved_attrs, :wrapped

  def initialize(wrapped_klass, new_attrs)
    @wrapped = wrapped_klass.new new_attrs
    @wrapped.save
    @saved_attrs = new_attrs.clone
  end

  # FIXME special case until 1.9 I think
  def id
    @wrapped.id
  end

  def method_missing(m, *a, &b)
    if m.to_s[-1..-1] == '='
      res = @wrapped.send m, *a, &b
      @wrapped.save
      attr = m.to_s[0...-1]
      @saved_attrs[attr] = res if @saved_attrs.include? attr
      res
    else
      @wrapped.reload
      @wrapped.send m, *a, &b
    end
  end
end
