require_relative 'engine'

# A Step
# Has one snippet (basic template)
# Has 0..1 guard  one argument (variable) that specifies the multiplicity of the step.
# Like in Mustache: conditional or repeating
# Has 0..* arguments (test variables)
class Step
  # A simple text template that is used to render the step
  # in the test script format.
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
    @guard = validated_guard(theGuard)
    @snippet = validated_snippet(theSnippet)
  end

  # Emit the snippet code given the values assigned to variables
  # in anEnvironment or theLocals
  def render(anEnvironment, theLocals, aTransformer, aLevel)
    return '' unless guard_applies?(anEnvironment, theLocals)
    
    return snippet.render(anEnvironment, theLocals, aTransformer, aLevel)
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


  def validated_snippet(theSnippet)
    template = Engine.new.compile(theSnippet)

    # Check that the variables named in the template are
    # names of arguments of the step
    placeholders = template.placeholders()
    all_names = arguments.map(&:name)

    placeholders.each do |a_placeholder|
      var_named = a_placeholder.name
      unless all_names.include? var_named
        err_msg = "Step snippet refers to '#{var_named}' which isn't a step argument"
        fail StandardError, err_msg
      end
    end

    return template
  end
  
  def guard_applies?(anEnvironment, theLocals)
    # In absence of a guard, the step is unconditional
    return true if guard.nil?
    
    
    if anEnvironment.include?(guard.name)
      return anEnvironment[guard.name] ? true : false
    end
    
    if theLocals.include?(guard.name)
      return locals[guard.name] ? true : false
    end
    
    return false
  end

end # class