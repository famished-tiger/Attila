# A Step
# Has one snippet (basic template)
# Has 0..1 guard  one argument (variable) that specifies the multiplicity of the step.
# Like in Mustache: conditional or repeating
# Has 0..* arguments (test variables)
class Step
  # A simple text template that is used to render the step
  # in the test script format 
  attr_reader(:snippet)
  
  # The step arguments
  attr_reader(:arguments)
  
  # Optional. Zero or one link to one of the step argument.
  # Its value will specify the multiplicity of the step at rendition.
  # Like in Mustache: conditional or repeating.
  attr_reader(:guard)
  
  # Constructor
  def initialize(theArguments, theSnippet, theGuard = nil)
    @arguments = validated_arguments(theArguments)
    @snippet = theSnippet
    @guard = validated_guard(theGuard)
  end
  
  
  private
  
  def validated_arguments(theArgs)
    return theArgs.dup
  end
  
  def validated_guard(theGuard)
    if theGuard
      unless arguments.include? theGuard
        err_msg = "Guard '#{theGuard.name}' isn't a step argument."
        fail StandardError, err_msg
      end
    end
  
    return theGuard
  end
  
end # class