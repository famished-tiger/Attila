# encoding: utf-8	You should see a paragraph character: §
# File: Repeating.rb

# Mix-in module that provides services to manage a multiplicity attribute.
# Internally, the multiplicities are represented as symbolic values.
# However client code can use alternative multiplicity syntaxes that are more user-readable.
# Requirements:
# Classes that mix-in this module are required to have a constant named ForbiddenMultiplicities
module Repeating
	# Arbitrary numeric constant that represents the 'many' multiplicity
	Many = 987654

	# This constant lists all the known multiplicity symbols
	Multiplicities = [ :none, :zero_or_one, :one, :zero_or_more, :one_or_more ]

	# The multiplicity is the possible number of occurrences. Must be one of symbolic value defined in the Multiplicities constant.
	# It is the responsibility of the host class to initialize this attribute.
	attr_reader(:multiplicity)

public
	# Safe setter for the multiplicity attribute.
	# Depends: on existence of constant ForbiddenMultiplicities in host class.
	def multiplicity=(aMultiplicity)
		# Control that the multiplicity argument is syntactic correct
		valid_multiplicity = validate_multiplicity(aMultiplicity)
		
		# Control that the multiplicity value fulfills the multiplicity constraints of the host class
		hostClass = self.class
		if hostClass::ForbiddenMultiplicities.include? valid_multiplicity
			raise ScriptError, "Forbidden multiplicity: #{aMultiplicity} for a #{hostClass}."		
		else
			@multiplicity = valid_multiplicity
		end
	end
	
	# Return true iff multiplicity is :one, :one_or_more.
	# In other words, the method checks whether at least one occurrence is required.
	def required?()
		return ((multiplicity == :one) ||(multiplicity == :one_or_more))
	end
	
	# Return true iff multiplicity can be above one (i.e. :zero_or_more, :one_or_more)
	def multiple?
		return ((multiplicity == :zero_or_more) ||(multiplicity == :one_or_more))
	end
	
private		
	# Check that the passed multiplicity in argument is correct.
	# Return the validated value
	def validate_multiplicity(aMultiplicity)
		case aMultiplicity
			when Symbol
				raise ScriptError, "Unknown multiplicity symbol #{aMultiplicity}" unless Repeating::Multiplicities.include? aMultiplicity
				result = aMultiplicity
				
			when 1
				result = :one
				
			when Range
				result = validate_range(aMultiplicity)
				
			else
				raise ScriptError, "Unsupported multiplicity '#{aMultiplicity}'"
		end
		
		return result
	end
	
	# Specialised validation method to control a multiplicity expressed as a Range object
	def validate_range(aMultiplicity)
		lowerBound = aMultiplicity.min
		
		# Validate lower bound multiplicities
		case lowerBound
			when 0, 1
				# Valid: do nothing...

			when Many
				raise ScriptError, "multiplicity 'many' can only be used as fallows: 0..many or 1..many "
			else
				raise ScriptError, "Unsupported lower multiplicity value: '#{lowerBound}'"
		end
		
		upperBound = aMultiplicity.max
		# Validate lower bound multiplicities
		case upperBound	
			when 0
				result = :none
				
			when 1
				result = (lowerBound == 0) ? :zero_or_one : :one

			when Many
				result = (lowerBound == 0) ? :zero_or_more : :one_or_more
			else
				raise ScriptError, "Unsupported upper multiplicity value: '#{lowerBound}'"
		end		
		
		return result
	end

	# Hook (callback) method that is invoked when a class includes this module.
	# We use to check that a host class satisfies the requirement of this module
	def Repeating::included(includingModuleOrClass)
		raise ScriptError, "Missing constant named ForbiddenMultiplicities in class #{includingModuleOrClass}." unless includingModuleOrClass.const_defined?(:ForbiddenMultiplicities)
	end

end # module

# End of file