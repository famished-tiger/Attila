# File: template-visitor.rb
# Purpose: Implementation of the Template class.


#module Attila # Module used as a namespace

  # Module containing all classes implementing the simple template engine
  # used internally in Attila.
#  module Templating

    # A factory of enumerators specialized in visiting
    # template(element)s
    class TemplateVisitor
    
      class VisitStack
        attr_reader(:nesting_level)
        attr_reader(:stack)
        
        
        def initialize(anInitialLevel)
          @nesting_level = anInitialLevel
          @stack = []
        end
        
        public
        def empty?()
          return @stack.empty?
        end
        
        def push(anElement)
          if anElement.kind_of?(Array)
            stack.push(anElement.dup)  # Use dup to prevent aliasing
            @nesting_level += 1
          else
            stack.push(anElement)
          end
        end
 

        def pop()
          top = stack.pop
          
          if top.kind_of?(Array)
            if top.empty?
              @nesting_level -= 1
              element = nil
            else
              element = top.shift()
              stack.push(top)				
            end
          else
            element = top
          end
          
          return element
        end
        
      end # class

      public
      
      # Three visit events:
      # [:visit, visited_element, current depth]
      # [:before_children, parent, parent depth, child count]
      # [:after_children, parent, parent depth]
      # They occur in the same order as above.
      def self.build(theRoot, aContext, aLevel)
        visitor = Enumerator.new do |client|	# client is a Yielder
          # Initialization part: execute once
          context = aContext
          visit_stack = VisitStack.new(aLevel)
          visit_stack.push(theRoot)	# The LIFO queue of nodes to visit
          curr_path = []

          begin # Traversal part (as a loop)
            top = visit_stack.pop()
            if top.nil?
              client << [:after_children, curr_path.pop, visit_stack.nesting_level]
              next
            else
              element = top
            end
            
            next unless element.visitable?(context)
            
            client << [:visit, element, visit_stack.nesting_level ]	# Return the result
            
            if element.composite?
              client << [:before_children, element, visit_stack.nesting_level, element.children.size]
              curr_path.push(element)
              visit_stack.push(element.children)
            end
          end until visit_stack.empty?
        end

        return visitor
      end
      
=begin
      # Three visit events:
      # [:visit, visited_element, current depth]
      # [:before_children, parent, parent depth, child count]
      # [:after_children, parent, parent depth]
      # They occur in the same order as above.
      def self.build(theRoot, aContext, aLevel)
        visitor = Enumerator.new do |client|	# client is a Yielder
          # Initialization part: execute once
          context = aContext
          curr_depth = aLevel
          visit_stack = [ theRoot ]	# The LIFO queue of nodes to visit
          curr_path = []

          begin # Traversal part (as a loop)
            top = visit_stack.pop()
            if top.kind_of?(Array)
              if top.empty?
                curr_depth -= 1
                client << [:after_children, curr_path.pop, curr_depth]
                next
              else
                element = top.shift()
                visit_stack.push(top)				
              end
            else
              element = top
            end
            
            next unless element.visitable?(context)
            
            client << [:visit, element, curr_depth ]	# Return the result
            
            if element.composite?
              client << [:before_children, element, curr_depth, element.children.size]
              curr_path.push(element)
              visit_stack.push(element.children.dup) # prevent aliasing w. dup
              curr_depth += 1
            end
          end until visit_stack.empty?
        end

        return visitor
      end
=end
    end # class


#end # module

#end # module

# End of file