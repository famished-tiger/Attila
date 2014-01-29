# Goal for this PoC: generate test cases for "Contact create via EPP" use case
require_relative 't-variable'
require_relative 'step'

=begin
Skeleton of (successful scenario)

Scenario: Base scenario for creating a reseller contact
	When I want to create an "reseller" contact with data:
	|Tag						|Value							|
  # This is a comment
	|alias					|client_id001  |
	|name						|Teki-Sue Porter	|
{{}}	|organisation		|Tech Support Unlimited |
	|postal code		|1234								|
	|city						|Nowhere City				|
	|phone					|+32.123456789			|
	|fax						|+32.123456790			|
	|email					|nobody@example.com	|
	|country code		|BE									|
	|language				|en									|
	And I add the street:
	|street															|
	|Main Street 122  |

	Then I expect to see success
  
For error scenarios we expect the last step to
be replaced by:
  And I expect to see the error details:
  |Tag | Value |
  | tag| undef|
  | reason |The contact §{contact_to_delete51} is not linked to the registrarAccount ~{Registrar.id}.|
=end


# Bottom-up implementation strategy:
# At lowest-level, the use case consists of steps.









