# File: eo-line.rb

require_relative 'template-element'

module Attila # Module used as a namespace

  # Module containing all classes implementing the simple template engine
  # used internally in Attila.  
  module Templating
  
    # Class used internally by the template engine.  
    # Represents an end of line that must be rendered as such.
    class EOLine < TemplateElement
      # This constant lists all the allowed ways to render an eol/newline.
      RenderingModes = {
        as_is:    ->(inst) { inst.source }, # Render as it appeared in the original template text.
        default:  ->(inst) { $/ },
        cr:       ->(inst) { "\r" },  # Render as a CR character
        crlf:     ->(inst) { "\r\n" },  # Render as a CR LF sequence
        lf:       ->(inst) { "\n" } # Render as a LF character
      }
    
      # An indication on how end of line should be rendered
      attr_reader(:rendering)
      
      # @param aSourceText [String] A piece of text extracted 
      #   from the template that must be rendered verbatim.
      def initialize(aSourceText, theRendering)
        super(aSourceText)
        @rendering = valid_rendering(theRendering)
      end

      public
      
      # Render an end of line.
      # This method has the same signature as the {Engine#render} method.
      # @return [String] An end of line marker. Its exact value is OS-dependent.
      def render(aContextObject, theLocals)
      
        return RenderingModes[rendering].call(self)
      end
      
      private
      # Validation method. Return the validated rendering mode.
      # An exception is raised when the validation fails.
      def valid_rendering(theRendering)
        unless RenderingModes.keys.include?(theRendering)
          err_msg = "Unsupported end of line rendering mode '#{theRendering}'"
          fail StandardError, err_msg
        end
        
        return theRendering
      end
      
    end # class

  end # module

end # module

# End of file