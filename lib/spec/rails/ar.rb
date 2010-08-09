require 'rubygems'
require 'xgem'

require 'x/activerecord_base_attributise'

require 'active_record'

require 'spec/orm'


class ActiveRecord::Base
  class << self
    alias :inherited_b4_rspec_ar :inherited
    def inherited(sub)
      Spec::Orm.wrap sub
      inherited_b4_rspec_ar sub
    end
  end
end

ObjectSpace.each_object(Class) { |k|
  Spec::Orm.wrap k if k.superclass == ActiveRecord::Base }

module WrappedArMatchers
  # attributes' keys are strings in AR!
  def be_the_same_but(diff)
    simple_matcher("have #{diff.inspect} and the others unchanged") do |tgt,mr|
      attrs = tgt.attributes  # performance considerations
      exp_attrs = tgt.saved_attrs.merge tgt.attributise(diff)
      mr.failure_message =
        "expected #{tgt.wrapped.inspect} to have #{exp_attrs.inspect}"
      not exp_attrs.detect { |a,e| attrs[a.to_s] != e }
    end
  end

  def be_the_same
    be_the_same_but({})
  end
end

Spec::Runner.configure do |config|
  config.include(WrappedArMatchers, :type => [:controller])
end
