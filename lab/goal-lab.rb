TestModel = Struct.new(:goals   # All the goals in context
)

Goal = Struct.new(:name, :statement)


# A sequence is a serie of plan elements that are
# executed in a definite order
class Sequence
  attr_reader(:elements)
  
  def initialize(theElements)
    @elements = theElements
  end
end # class


class CompositeGoal < Goal
  attr_reader(:plan)
  
  def initialize(aName, aStatement, aPlan)
    super(aName, aStatement)
    @plan = aPlan
  end
  
  public
  
  def subgoals()
  end
  
  private

end # class


class LeafGoal < Goal
  attr_reader(:procedure)
  
  def initialize(aName, aStatement, aProcedure)
    super(aName, aStatement)
    @procedure = aProcedure
  end
  
  public
  
  def subgoals()
    return []
  end
end # class



OrphanLink = Struct.new(:name)


class GoalRef
  attr_reader(:goal)
  
  def initialize(aLinkToGoal)
    @goal = case aLinkToGoal
    when Goal then aLinkToGoal
    when Symbol then OrphanLink.new(aLinkToGoal)
    end
  end
  
  def name()
    return goal.name
  end
end


class CompositeGoalBuilder
  
  def initialize(aName, aStatement, &aBlock)
    @name = aName
    @statement = aStatement

    instance_eval(&aBlock)
  end
  
  def plan(&aBlock)
    @plan = []
    instance_eval(&aBlock)
  end

  def sequence(&aBlock)
    @plan << Sequence.new([])
    instance_eval(&aBlock)
  end
  
  def subgoal(aName)
    ref = GoalRef.new(aName)
    @plan.last.elements << ref
  end
  
  def run()
    return CompositeGoal.new(@name, @statement, @plan)
  end
end # class


class LeafGoalBuilder
  
  def initialize(aName, aStatement, &aBlock)
    @name = aName
    @statement = aStatement

    instance_eval(&aBlock) 
  end
  
  def procedure(sourceText)
    @procedure = sourceText.dup
  end
  
  def run()
    return LeafGoal.new(@name, @statement, @procedure)
  end
end # class


# Re-open the TestModel Struct
class TestModel


  def initialize()
    super({})
  end

  def composite_goal(aName, aStatement, &aBlock)
    builder = CompositeGoalBuilder.new(aName, aStatement, &aBlock)
    new_goal = builder.run
    add_goal(new_goal)
    return new_goal
  end
  
  def leaf_goal(aName, aStatement, &aBlock)
    builder = LeafGoalBuilder.new(aName, aStatement, &aBlock)
    new_goal = builder.run
    add_goal(new_goal)
    return new_goal
  end
  
  # Notify that the goal model is fully populated.
  def completed()
  end
  
  # Retrieve the topmost, root, goal
  def main_goal()
    # TODO: replace naive implementation
    return goals.values.first
  end
  
  private
  def add_goal(aGoal)
    goals[aGoal.name] = aGoal
  end


end # module


module GoalModelBuilder
  def goal_model(&aBlock)
    t_context = TestModel.new
    t_context.instance_eval(&aBlock)
    t_context.completed
    return t_context
  end


end # module



self.extend(GoalModelBuilder)