require 'xgem'

require 'x/constinsts'
require 'x/csv_send'

require 'x/intense_orm_wrapper'

require 'spec/wrapped_orm_matchers'


module Spec::Orm
  class << self
    def wrap(klass)
      klass.class_eval do
        include Constinsts

        def self.constinst_new(attrs)
          IntenseOrmWrapper.new self, attrs
        end
      end
    end
  end
end

Spec::Runner.configure do |config|
  config.include(WrappedOrmMatchers, :type => [:controller])
end
