# File: template.rb
# Purpose: Implementation of the Template class.

require_relative 'context'
require_relative 'template-visitor'
require_relative 'composite'

module Attila # Module used as a namespace

  # Module containing all classes implementing the simple template engine
  # used internally in Attila.
  module Templating

    class Template
      include Composite # Add parent behaviour from this mix-in module
      # The template child elements
      attr_reader(:elements)
      
      # Define 'children' as an alias to 'elements' method
      alias children elements
    
      public

      def initialize(theChildElements)
        @elements = theChildElements
      end
      
      def render(anEnvironment, theLocals, aTransformer, aLevel)
        context = Context.new(anEnvironment, theLocals)
        
        visitor = TemplateVisitor.build(self, context, aLevel)
        result = ''
        visitor.each do |visit_event|
          (event_kind, visitee, level) = visit_event

          case event_kind
            when :visit
              result << visitee.sub_render(aTransformer, context, level)

            when :before_children
              count = visit_event.last
              result << visitee.before_children(aTransformer, context, level, count)
              
            when :after_children
              result << visitee.after_children(aTransformer, context, level)
          end
        end
        
        return result
      end
      
      def to_text()
        return ''
      end

  
    end # class

end # module

end # module

# End of file