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
  def initialize(theSnippet, theArguments, theGuard = nil)
    @snippet = theSnippet
    @arguments = theArguments
    @guard = theGuard
  end
  
end # class