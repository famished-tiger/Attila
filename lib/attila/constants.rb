# File: constants.rb
# Purpose: definition of Attila constants.

module Attila # Module used as a namespace
  # The version number of the gem.
  Version = '0.0.02'

  # Brief description of the gem.
  Description = 'Macro-steps for Cucumber'

  # Constant Attila::RootDir contains the absolute path of Attila's
  # root directory. Note: it also ends with a slash character.
  unless defined?(RootDir)
  # The initialisation of constant RootDir is guarded in order 
  # to avoid multiple initialisation (not allowed for constants)

    # The root folder of Attila.
    RootDir = begin
      require 'pathname'	# Load Pathname class from standard library
      rootdir = Pathname(__FILE__).dirname.parent.parent.expand_path
      rootdir.to_s + '/'	# Append trailing slash character to it
    end
  end
end # module

# End of file
