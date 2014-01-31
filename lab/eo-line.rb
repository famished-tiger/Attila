# File: eo-line.rb

require_relative 'template-element'  # Load superclass

#module Attila # Module used as a namespace

  # Module containing all classes implementing the simple template engine
  # used internally in Attila.  
#  module Templating
  
    # Class used internally by the template engine.  
    # Represents an end of line that must be rendered as such.
    class EOLine < TemplateElement
      public
      
      def composite?() false; end
    end # class

#  end # module

#end # module

# End of file