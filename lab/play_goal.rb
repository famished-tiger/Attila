# Hyper-simplified goal model

require 'pp'
require_relative 'goal-lab'

# Plan consists of plan element:
# - a strict sequence of plan elements
# - an arbitrary sequence of plan elements
# - a goal (composite or leaf)
# - a prioritized list of plan elements

# Inspirations: 
# - JSD diagrams(regular FSM): decomposition into: sequence, alternative, repetition
# - Grammars: sequence, alternative, repetition or recursitivity, PEG: prioritized list
# - How to model occurrence of asynchronous events (e.g. cancellation/withdrawal)

# What to do in case of failure?
# When a goal fails then its enclosing region/parent goal receives a failure object/event.
# If there is a handler for the kind failure, then a goal is activated
# Otherwise the region/parent goal fails with the received object/event. 
# Q: In case of escalation maybe the failure object can be transformed 
# (with previous failure object put as cause -cascaded exceptions-).



# - execution mode: driven by values taken by test variables.
# - when 'executing' a plan element will have two side effects:
# - generate an outcome event (success/failure)
# - Add to the execution trace.


# - Terminology: simulate.

test_model = model do

composite_goal :log_on, "log onto MyApp with {{credentials}}" do
  plan do
    sequence do
      subgoal :goto_login_page
      
      # Mandatory for parent's goal success.
      # How to indicate that this goal is skipped when user_id isn't entered?
      subgoal :enter_user_id 
      subgoal :enter_password
      subgoal :submit_credentials
    end # sequence
  end # plan
end # goal


leaf_goal :goto_login_page, "navigate to MyApp login page" do
  procedure <<-SNIPPET
  When I go the page of MyApp
SNIPPET
end

leaf_goal :enter_user_id, "enter user id {{credentials.user_id}}" do
  procedure <<-SNIPPET
  When I fill user_id with {{credentials.user_id}}
SNIPPET
end
  
leaf_goal :enter_password, "enter password {{credentials.password}}" do
  procedure <<-SNIPPET
  """
  When I fill password with {{credentials.password}}
SNIPPET
end

leaf_goal :submit_credentials, "submit the credentials" do
  procedure <<-SNIPPET
  """
  When I press the button "Login"
SNIPPET
end

end # model

pp test_model
main_goal = test_model.goals[test_model.goals.keys.first]
pp main_goal.plan

sub_goal = test_model.goals[test_model.goals.keys[1]]
pp sub_goal.procedure


# End of file
