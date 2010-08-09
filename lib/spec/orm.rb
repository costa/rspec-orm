require 'xgem'

require 'x/recurse'
require 'x/constinsts'
require 'x/csv_send'  # a utility require

require 'x/intense_orm_wrapper'


module Spec::Orm
  class << self
    def wrap(klass)
      klass.class_eval do
        include Constinsts

        # FIXME? the side effect is changing the attrs
        def self.constinst_new(*attrs)
          IntenseOrmWrapper.new self, *attrs.recurse!{ |e|
            if e.is_a? IntenseOrmWrapper then e.wrapped else e end }
        end
      end
    end
  end
end
