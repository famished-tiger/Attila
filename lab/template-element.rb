# File: template-element.rb
# Purpose: Implementation of the TemplateElement class.

#require_relative '../../abstract-method'
require_relative '../lib/abstract-method'

#module Attila # Module used as a namespace

  # Module containing all classes implementing the simple template engine
  # used internally in Attila.  
#  module Templating

      # Abstract class. Represents any element occurring in a compiled template.
      class TemplateElement
        include AbstractMethod
        
        # The text from the original template that corresponds to this element.
        attr_reader(:source)


        # @param aSourceText [String] A piece of text extracted 
        #   from the template that must be rendered verbatim.
        def initialize(aSourceText)
          @source = aSourceText
        end

        public
        
        # Purpose: to render the element.
        # @return [String]
        def sub_render(aTransformer, aContextObject, aLevel)
          return aTransformer.transform(self, aContextObject, aLevel)
        end
        
        # Returns a String representation of the element.
        # The default implementation returns the original source text.
        def to_text()
          return source
        end
        
        def composite?() abstract_method; end
        
        def visitable?(aContext) true; end
        
      end # class

#  end # module

#end # module

# End of file
