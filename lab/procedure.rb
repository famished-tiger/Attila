# File: procedure.rb


# Informally, a procedure is a serie of steps that are required to fulfil 
# a particular goal.
# A procedure is an ordered sequence of one or more sequence of steps.
# TODO: extend with logic-less construct: conditional and repeated sections.
class Procedure
  # The ordered set of sequences of steps.
	attr_reader(:steps)

  # Constructor.
  # [theStepSequences] an array of Steps
	def initialize(theSteps)
		@steps = theSteps
	end
  
  public
  
	# Purpose: retrieve all the test variables names that appear in the steps.
	# Dependency rule for procedures: a procedure depends only on the test variables (not on the choices)
	# that are used in the steps.
	def dependencies(recursive = false)
		steps_dependencies = steps.reduce([]) do |subresult, a_step|
			subresult.concat(a_step.arguments())
			subresult
		end

		return steps_dependencies.uniq()
	end
  
  def render(anEnvironment, theLocals, aTransformer, aLevel)
    result = steps.reduce('') do |subresult, a_step|
      subresult << a_step.render(anEnvironment, theLocals, aTransformer, aLevel)
    end
    
    return result
  end
end # class

# End of file