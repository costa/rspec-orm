require 'xgem'

require 'x/string_cut'

# new-save-reload protocol expected from the wrapped class (both AR & DM)
# FIXME -attributise too!
# FIXME what about specs?
class IntenseOrmWrapper  # FIXME? suggest a better silly name, what? :-)

  attr_reader :saved_attrs, :wrapped

  def initialize(wrapped_klass, new_attrs)
    @wrapped = wrapped_klass.new new_attrs
    @wrapped.save
    @saved_attrs = @wrapped.attributise(new_attrs)
  end

  # FIXME special case until 1.9 I think
  def id
    @wrapped.id
  end

  def method_missing(m, *a, &b)
    attr, eq = m.to_s.cut(-1)
    if eq == '='
      res = @wrapped.send m, *a, &b
      @wrapped.save
      @saved_attrs[attr] = res if @saved_attrs.include? attr
      res
    else
      @wrapped.reload
      @wrapped.send m, *a, &b
    end
  end
end
