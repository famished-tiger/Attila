# File: transformer.rb

require_relative 'template-element'

#module Attila # Module used as a namespace

  # Module containing all classes implementing the simple template engine
  # used internally in Attila.
#  module Templating

    # Class used internally by the template engine.
    # A Context provides a lookup capability.
    # It allows to retrieve the value associated with a given template variable.
    class Context
     # An object with attributes that returns the value of the corresponding template variable.
      attr_reader(:scope)
     
      # A Hash containing key/value pairs that augment or override
      # the pairs from the context objects.
      attr_reader(:locals)
    
      def initialize(theScope, theLocals)
        @scope = theScope
        @locals = theLocals
      end
    
      public

      # @return [Object] The actual value from the locals or context
      # that is assigned to the variable.
      def [](aName)
        actual_value = locals[aName]
        
        if actual_value.nil?
          if scope.respond_to?(aName.to_sym)
            actual_value = scope.send(aName.to_sym)
          else
            actual_value = scope[aName]
          end
        end
        
        return actual_value
      end
    
    end # class

#  end # module

#end # module

# End of file