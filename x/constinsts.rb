
# provides automatic "constant instances" for an including Klass,
# referred to as Klass.Konst, and checked for existence with Klass.Konst?
#
# supply the first reference with the #new arguments, if desired: Klass.Konst(1)
#
# the including Klass may have Klass.constinst_new method defined which is then
# used instead of Klass.new in constinst "automatic" creation

# TODO? it probably only works when included in a class (not a module)
module Constinsts
  def self.included(mod)
    return if mod.respond_to? :constinsts
    class << mod
      attr_accessor :constinsts

      alias :method_missing_b4_constinsts :method_missing

      def method_missing(m, *a, &b)
        @constinsts ||= { }
        if m.to_s[0..0] =~ /[A-Z]/

          return @constinsts.include? m.to_s[0..-2].to_sym if
            m.to_s[-1..-1] == '?'  # FIXME disregarding arguments, if any

          raise "assignment unsupported, please use the #new-like syntax" if
            m.to_s[-1..-1] == '='  # FIXME should be supported actually

          if @constinsts.include? m
            if a.empty? and not block_given?
              @constinsts[m]
            else
              # TODO: warning: already initialized constant #{m.to_s}
              @constinsts[m] = if respond_to? :constinst_new then
                                 constinst_new(*a, &b) else new(*a, &b) end
            end
          else
            @constinsts[m] = if respond_to? :constinst_new then
                               constinst_new(*a, &b) else new(*a, &b) end
          end
        else
          method_missing_b4_constinsts(m, *a, &b)
        end
      end
    end
  end
end
