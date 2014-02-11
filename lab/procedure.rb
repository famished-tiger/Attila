# File: procedure.rb


# Informally, a procedure is a serie of steps that are required to fulfil 
# a particular goal.
# A procedure is an ordered sequence of one or more sequence of steps.
class Procedure
  # The ordered set of sequences of steps.
	attr_reader(:steps)

  # Constructor.
  # [theStepSequences] an array of StepSequence
	def initialize(theStepSequence)
		@steps = theStepSequences
	end
  
  public
  
	# Purpose: retrieve all the test variables names that appear in the steps.
	# Dependency rule for procedures: a procedure depends only on the test variables (not on the choices)
	# that are used in the steps.
	def dependencies(recursive = false)
		steps_dependencies = step_sequences.reduce([]) do |subresult, a_step|
			subresult.concat(step.arguments())
			subresult
		end

		return steps_dependencies.uniq()
	end
  
  def render(anEnvironment, theLocals, aTransformer, aLevel)
    return snippet.render(anEnvironment, theLocals, aTransformer, aLevel)
  end
end # class

# End of file