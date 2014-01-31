# File: static-text.rb

require_relative 'template-element' # Load superclass

#module Attila # Module used as a namespace

  # Module containing all classes implementing the simple template engine
  # used internally in Macros4Cuke.  
#  module Templating

      # Class used internally by the template engine.  
      # Represents a piece of text from a template that 
      # must be reproduced verbatim when rendering the template.
      class StaticText < TemplateElement
      
        def composite?() false; end
      end # class

#  end # module

#end # module

# End of file