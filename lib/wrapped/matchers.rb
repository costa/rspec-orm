
# attributes method is also currently expected from the wrapped class (AR & DM)
module WrappedOrmMatchers

  def be_the_same_but(diff)
    simple_matcher("have #{diff.inspect} and the others unchanged") do |tgt,mr|
      exp_attrs = tgt.saved_attrs.merge(diff)
      attrs = tgt.attributes  # FIXME attributes' keys are strings!
      mr.failure_message =
        "expected #{tgt.wrapped.inspect} to have #{exp_attrs.inspect}"
      not exp_attrs.detect { |a,e| attrs[a.to_s] != e }
    end
  end

  def be_the_same
    be_the_same_but({})
  end
end
