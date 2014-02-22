# encoding: utf-8 -- You to see a paragraph character: §
# File: pepeating_spec.rb

require_relative 'spec_helper'

require_relative 'repeating'	# The module under testing


describe Repeating do

# Invent a first host class just for testing purpose
class TestingMandatoryMultiplicities
	# Constant required by the Repeating module
	ForbiddenMultiplicities = [:none, :zero_or_one, :zero_or_more]
	
	include Repeating	# Mix-in the features from Repeating	

	
	# Constructor
	def initialize(aMultiplicity)
		self.multiplicity = aMultiplicity	# Use a method acquired from Repeating module
	end

end # class

# Invent a second host class just for testing purpose
class TestingOptionalMultiplicities
	# Constant required by the Repeating module
	ForbiddenMultiplicities = [ :one, :one_or_more]

	include Repeating	# Mix-in the features from Repeating
	
	# Constructor
	def initialize(aMultiplicity)
		self.multiplicity = aMultiplicity	# Use a method acquired from Repeating module
	end

end # class
	
	
	# Helper method. Wrap the Repeating::Many constant with light syntactic sugar
	def many()
		return Repeating::Many
	end
	
	it 'to initialize a mandatory multiplicity' do
		# Try a number of equivalent syntaxes for multiplicity == exactly one
		exactly_one = [
			:one,	# Multiplicity value as Symbol (internal representation)
			1,		# Multiplicity value as integer
			(1..1)	# Multiplicity value as Range
		]
		
		exactly_one.each do |a_multiplicity|
			repeatable = TestingMandatoryMultiplicities.new(a_multiplicity)
			expect(repeatable.multiplicity).to eq(:one)
			expect(repeatable).to be_required
			expect(repeatable).not_to be_multiple
		end
		
		# Try a number of equivalent syntaxes for multiplicity == one or more
		one_or_more = [
			:one_or_more,	# Multiplicity value as Symbol (internal representation)
			(1 .. many)		# Multiplicity value as Range
		]
		one_or_more.each do |a_multiplicity|
			repeatable = TestingMandatoryMultiplicities.new(a_multiplicity)
			expect(repeatable.multiplicity).to eq(:one_or_more)
			expect(repeatable).to be_required
			expect(repeatable).to be_multiple
		end
	end
	
	it 'to initialize an optional multiplicity' do	
		# Try a number of equivalent syntaxes for multiplicity == zero or one
		zero_or_one = [
			:zero_or_one,	# Multiplicity value as Symbol (internal representation)
			(0..1),	# Multiplicity value as Range
		]
		
		zero_or_one.each do |a_multiplicity|
			repeatable = TestingOptionalMultiplicities.new(a_multiplicity)
			expect(repeatable.multiplicity).to eq(:zero_or_one)
			expect(repeatable).not_to be_required
			expect(repeatable).not_to be_multiple
		end
		
		# Try a number of equivalent syntaxes for multiplicity == zero or more
		zero_or_more = [
			:zero_or_more,	# Multiplicity value as Symbol (internal representation)
			(0 .. many)		# Multiplicity value as Range
		]
		zero_or_more.each do |a_multiplicity|
			repeatable = TestingOptionalMultiplicities.new(a_multiplicity)
			expect(repeatable.multiplicity).to eq(:zero_or_more)
			expect(repeatable).not_to be_required
			expect(repeatable).to be_multiple
		end
		
		# Special case: for the :none multiplicity, the Symbol syntax only is allowed
		not_occurring = TestingOptionalMultiplicities.new(:none)
		expect(not_occurring.multiplicity).to eq(:none)
		expect(not_occurring).not_to be_required
		expect(not_occurring).not_to be_multiple
	end
	
	it 'to reject syntactically incorrect multiplicities' do
		invalid_ones = [
			:arbitrary_symbol,
			2,
			0,
			(2..many),
			(many..many)
		]
		
		invalid_ones.each do |bad_syntax|
			expect { TestingMandatoryMultiplicities.new(bad_syntax) }.to raise_error(StandardError)
		end
	end
	
	it 'to reject multiplicities forbidden by the host class' do
		forbidden_for_mandatory = [
			:zero_or_one,
			(0..1),
			:zero_or_more,
			(0..many),
			:none
		]
		forbidden_for_mandatory.each do |forbidden|
			expect { TestingMandatoryMultiplicities.new(forbidden) }.to raise_error(StandardError)
		end
		
		forbidden_for_optional = [
			:one,
			1,
			(1..1),
			:one_or_more,
			(1..many),
		]
		forbidden_for_optional.each do |forbidden|
			expect { TestingOptionalMultiplicities.new(forbidden) }.to raise_error(StandardError)
		end		
	end

end # describe


# End of file