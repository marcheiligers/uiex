#
# original comment:
#
#   forwardable.rb -
#       $Release Version: 1.1$
#       $Revision$
#       by Keiju ISHITSUKA(keiju@ishitsuka.com)
#       original definition by delegator.rb
#       Revised by Daniel J. Berger with suggestions from Florian Gross.
#
#       Documentation by James Edward Gray II and Gavin Sinclair

# Marc says: Removed the reference to Regexp since DRGTK does not have Regexp
#   original here: https://github.com/takahashim/mruby-forwardable/blob/master/mrblib/forwardable.rb

module Forwardable
  def instance_delegate(hash)
    hash.each do |methods, accessor|
      methods = [methods] unless methods.respond_to?(:each)
      methods.each do |method|
        def_instance_delegator(accessor, method)
      end
    end
  end

  def def_instance_delegators(accessor, *methods)
    methods.delete("__send__")
    methods.delete("__id__")
    methods.each do |method|
      def_instance_delegator(accessor, method)
    end
  end

  def def_instance_delegator(accessor, method, ali = method)
    # If it's not a class or module, it's an instance
    if self.class == Class || self.class == Module
      module_eval do
        define_method(ali) do |*args, &block|
          instance_variable_get(accessor).__send__(method.to_sym, *args, &block)
        end
      end
    else
      raise "Forwardable not supported object-level delegation"
    end
  end

  alias delegate instance_delegate
  alias def_delegators def_instance_delegators
  alias def_delegator def_instance_delegator
end
