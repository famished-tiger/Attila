# File: static-text.rb

require_relative 'template-element'

module Attila # Module used as a namespace

  # Module containing all classes implementing the simple template engine
  # used internally in Macros4Cuke.  
  module Templating

      # Class used internally by the template engine.  
      # Represents a piece of text from a template that 
      # must be reproduced verbatim when rendering the template.
      class StaticText < TemplateElement

        public

        # Overriding method. Render the static text.
        # This method has the same signature as the {Engine#render} method.
        # @return [String] Static text is returned verbatim ("as is")
        def render(aContextObject, theLocals)
          return source
        end
      end # class

  end # module

end # module

# End of file