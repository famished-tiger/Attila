# File: abstract-method.rb

# Mix-in module. Provides the method 'abstract_method' 
# that raises an exception with an appropriate message when called.
module AbstractMethod
  public
  
  # Call this method in the body of your abstract methods.
  # Example:
  # require 'AbstractMethod'
  # class SomeClass
  # include AbstractMethod # Add behaviour from AbstractMethod mix-in module 
  # ...
  # Consider that SomeClass has an abstract method called 'some_method'
  # Then it can be declared as abstract like this:
  # def some_method() abstract_method
  # end
  def abstract_method()
    # Determine the short class name of self
    class_name = self.class.name.split(/::/).last
    
    # Retrieve the top text line of the call stack
    top_line = caller.first
    
    # Extract the calling method name
    quoted_caller = top_line.scan(/`.+?$/).first
    caller_name = quoted_caller.gsub(/`|'/, '') # Remove enclosing quotes
    
    # Build the error message
    error_message = [ 
      "The method #{class_name}##{caller_name} is abstract.",
      "It should be implemented in subclasses of #{className}."
    ]
    fail NotImplementedError, error_message.join("\n")
  end
end # module

# End of file
