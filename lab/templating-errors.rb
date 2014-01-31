# File: templating-errors.rb

#module Attila # Module used as a namespace

#module Templating

# @abstract
# Base class for any exception explicitly raised by the templating classes.
class TemplatingError < StandardError
end # class


# Raised when a sub-step has an empty or blank argument name.
class EmptyArgumentError < TemplatingError
  def initialize(aText)
    super("An empty or blank argument occurred in '#{aText}'.")
  end
end # class


# Raised when an argument name contains invalid characters.
class InvalidCharError < TemplatingError
  def initialize(aTag, aWrongChar)
    msg = "The invalid sign '#{aWrongChar}' occurs in the argument '#{aTag}'."
    super(msg)
  end
end # class

#end # module

#end # module

# End of file