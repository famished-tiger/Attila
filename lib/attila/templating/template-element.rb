# File: template-element.rb
# Purpose: Implementation of the TemplateElement class.

require_relative '../../abstract-method'

module Attila # Module used as a namespace

  # Module containing all classes implementing the simple template engine
  # used internally in Attila.  
  module Templating

      # Abstract class. Represents any element occurring in a compiled template.
      class TemplateElement
        
        # The text from the original template that corresponds to this element.
        attr_reader(:source)


        # @param aSourceText [String] A piece of text extracted 
        #   from the template that must be rendered verbatim.
        def initialize(aSourceText)
          @source = aSourceText
        end

        public

        # Abstract method. Purpose: to render the element.
        # This method has the same signature as the {Engine#render} method.
        # @return [String]
        def render(aContextObject, theLocals) abstract_method; end

      end # class

  end # module

end # module

# End of file
