require 'rubygems'

require 'active_record'

require 'spec/orm'


ObjectSpace.each_object(Class) { |k|
  Spec::Orm.wrap k if k.superclass == ActiveRecord::Base }

class ActiveRecord::Base
  class << self
    alias :inherited_b4_rspec_ar :inherited
    def inherited(sub)
      Spec::Orm.wrap sub
      inherited_b4_rspec_ar sub
    end
  end
end
