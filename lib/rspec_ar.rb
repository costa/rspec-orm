require 'rubygems'
require 'active_record'

require 'constinsts'
require 'csv_send'

require 'wrapped/wrapper.rb'
require 'wrapped/matchers.rb'


class ActiveRecord::Base
  class << self

    alias :inherited_b4_rspec_ar :inherited
    def inherited(sub)
      def sub.constinst_new(attrs)
        PenetratingOrmWrapper.new self, attrs
      end

      sub.class_eval { include Constinsts }

      inherited_b4_rspec_ar sub
    end
  end
end
