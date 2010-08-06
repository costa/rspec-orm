require 'rubygems'
require 'xgem'

require 'active_record'

require 'x/constinsts'
require 'x/csv_send'

require 'x/intense_orm_wrapper'

require 'spec/wrapped_orm_matchers'


class ActiveRecord::Base
  class << self

    alias :inherited_b4_rspec_ar :inherited
    def inherited(sub)
      def sub.constinst_new(attrs)
        IntenseOrmWrapper.new self, attrs
      end

      sub.class_eval { include Constinsts }

      inherited_b4_rspec_ar sub
    end
  end
end
