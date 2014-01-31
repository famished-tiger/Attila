# File: section.rb
# Purpose: Implementation of the Section and ConditionalSection classes.

require_relative 'unary-element' # Load the superclass


#module Attila # Module used as a namespace


# Module containing all classes implementing the simple template engine
# used internally in Attila. 
#module Templating

# Mix-in module implementing the behaviour of parent element.
# Assumption:
# Host class has a method called 'children that 
#   returns the children elements.
module Composite

  public
  
  def composite?() true; end
  
  def visitable?(aContext) true; end

  # Add one child element as member of the section
  def add_child(aChild)
    children << aChild
  end
  
  # Add an enumerable collection of children as member of the section
  def add_children(theChildren)
    theChildren.each { |a_child| self.add_child(a_child) }
  end


  # Purpose: to render the template itself.
  # @return [String]
  def sub_render(aTransformer, aContextObject, aLevel)
    return aTransformer.transform(self, aContextObject, aLevel)
  end
  
  
  def before_children(aTransformer, aContextObject, aLevel, aCount)
    return aTransformer.prepare(self, aContextObject, aLevel, aCount)
  end
  
  
  def after_children(aTransformer, aContextObject, aLevel)
    return aTransformer.complete(self, aContextObject, aLevel)
  end

end # module

#end # module

#end # module

# End of file