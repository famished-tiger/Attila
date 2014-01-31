# File: placeholder.rb
# Purpose: Implementation of the Placeholder class.

require_relative 'unary-element' # Load the superclass


#module Attila # Module used as a namespace

# Module containing all classes implementing the simple template engine
# used internally in Attila. 
#module Templating

  # Class used internally by the template engine.  
  # Represents a named placeholder in a template, that is, 
  # a name placed between <..> in the template.  
  # At rendition, a placeholder is replaced by the text value
  # that is associated with it. 
  class Placeholder < UnaryElement
    public
    
    def composite?() false; end
  
  end # class

#end # module

#end # module

# End of file
