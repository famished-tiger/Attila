# File: transformer.rb

require_relative 'template-element'

#module Attila # Module used as a namespace

  # Module containing all classes implementing the simple template engine
  # used internally in Attila.
#  module Templating

    # Class used internally by the template engine.
    # A transformer adapt the output format of template elements at their rendition.
    class Transformer

      # This constant lists all the allowed ways to render an eol/newline.
      EOLRenderingModes = {
        as_is:    ->(eol) { eol.source }, # Render as it appeared in the original template text.
        default:  ->(eol) { $/ },
        cr:       ->(eol) { "\r" },  # Render as a CR character
        crlf:     ->(eol) { "\r\n" },  # Render as a CR LF sequence
        lf:       ->(eol) { "\n" } # Render as a LF character
      }

            # An indication on how end of line should be rendered
      attr_reader(:eol_rendering)

      def initialize(eolRendering = :default)
        @eol_rendering = valid_rendering(eolRendering)
      end


      public
=begin
      def start(aContextObject, aLevel)
        return ''
      end

      def complete(aContextObject)
        return ''
      end
=end

      def transform(aTemplateElement, aContextObject, aLevel)
        # Deduct the transform method for the passed argument
        mth_name = method_name_for(aTemplateElement)
        if self.respond_to?(mth_name)
          result = self.send(mth_name, aTemplateElement, aContextObject, aLevel)
        else
          request = aTemplateElement.respond_to?(:to_text) ? :to_text : :to_s
          result = aTemplateElement.send(request)
        end

        return result
      end

      def prepare(aCompositeElement, aContextObject, aLevel, aCount)
        return ''
      end
      
      def complete(aCompositeElement, aContextObject, aLevel)
        return ''
      end


      protected


      def transform_eo_line(anEOLElement, aContextObject, aLevel)
        return EOLRenderingModes[eol_rendering].call(anEOLElement)
      end

      # Render the placeholder given the passed arguments.
      # This method has the same signature as the {Engine#render} method.
      # @return [String] The text value assigned to the placeholder.
      #   Returns an empty string when no value is assigned to the placeholder.
      def transform_placeholder(aPlaceholder, aContextObject, aLevel)
        actual_value = aContextObject[aPlaceholder.name]
        result = case actual_value
          when NilClass
            ''

          when Array
            # TODO: Move away from hard-coded separator.
            actual_value.join('<br/>')

          when String
            actual_value
          else
            actual_value.to_s
        end

        return result
      end

      private

      # Validation method. Return the validated rendering mode.
      # An exception is raised when the validation fails.
      def valid_rendering(theRendering)
        unless EOLRenderingModes.keys.include?(theRendering)
          err_msg = "Unsupported end of line rendering mode '#{theRendering}'"
          fail StandardError, err_msg
        end

        return theRendering
      end

      def method_name_for(aTemplateElement)
        class_name = aTemplateElement.class.name.split('::').last
        suffix = ''
        (0...class_name.size).each do |i|
          ch = class_name[i]
          lowercase = ch.downcase
          if (lowercase == ch)
            suffix << lowercase
          else
            case i
            when 0 then suffix << '_' + lowercase
            when class_name.size - 1 then suffix << lowercase
            else
              next_ch = class_name[i + 1]
              if next_ch.downcase == next_ch
                suffix << '_' + lowercase
              else
                suffix << lowercase
              end
            end
          end
        end

        return "transform#{suffix}".to_sym
      end

    end # class

#  end # module

#end # module

# End of file