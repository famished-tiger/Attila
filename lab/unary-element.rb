# File: unary-element.rb
# Purpose: Implementation of the Section and ConditionalSection classes.

require_relative 'template-element' # Load superclass

#module Attila # Module used as a namespace

  # Module containing all classes implementing the simple template engine
  # used internally in Attila.
#  module Templating

    # Astract class used internally by the template engine.  
    # The generalization of any element from a template that has one variable
    # whose actual value influences the rendition.
    class UnaryElement < TemplateElement
      # The name of the placeholder/variable.
      attr_reader(:name)
      
      # @param aVarName [String] The name of the placeholder from a template.
      def initialize(aVarName)
        @name = aVarName
      end
      
      # Purpose: to render the element.
      # @return [String]
      def sub_render(aTransformer, aContextObject, aLevel)
        return aTransformer.transform(self, aContextObject, aLevel)
      end
      

      protected


      # This method has the same signature as the {Engine#render} method.
      # @return [Object] The actual value from the locals or context
      # that is assigned to the variable.
      def value_from(aContextObject, aTransformer)
        return aContextObject.value_of(name)
      end
      
    end # class

#end # module

#end # module

# End of file
