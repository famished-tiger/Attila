# A finer-grained goal that cannot be decomposed further into subgoals.
# Such a goal is satisfied by executing a specific procedure (which is itself a serie of steps).
class ProceduralGoal
  attr_reader(:name)
  attr_reader(:statement)
  
	# The procedure (i.e. an ordered set of steps) required to satisfy the goal.
	attr_reader(:procedure)

	# The list of identified outcomes (success or failing) 
  # situations after the execution of the goal's procedure
	attr_reader(:outcomes)

  # Constructor.
  # [aName] The name of the goal. It must be unique within a dynamic model.  
  # [aStatement] The goal statement (as a Mustache template text)
  # [aProcedure] The procedure to execute in order to fulfill the goal.
	def initialize(aName, aStatement, aProcedure)
		@name = aName
    @statement = aStatement
		@procedure = aProcedure
		@outcomes = []
	end

end # class