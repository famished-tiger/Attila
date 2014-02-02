# File: engine.rb
# Purpose: Implementation of the Engine class.

require 'strscan' # Use the StringScanner for lexical analysis.
require_relative 'templating-errors' # Load the custom exception classes.


require_relative 'static-text'
require_relative 'eo-line'
require_relative 'placeholder'
require_relative 'template'


#module Attila # Module used as a namespace


# Module containing all classes implementing the simple template engine
# used internally in Attila.  
#module Templating

# A very simple implementation of a templating engine.  
# Earlier versions of Attila relied on the logic-less 
# Mustache template engine.  
# But it was decided afterwards to replace it by a very simple 
# template engine.  
# The reasons were the following:  
# - Be closer to the usual Gherkin syntax (parameters of scenario outlines 
#     use chevrons <...>, 
#     while Mustache use !{{...}} delimiters),  
# - Feature files are meant to be simple, so should the template engine be. 
class Engine
  # The regular expression that matches a space, 
  # any punctuation sign or delimiter that is forbidden
  # between chevrons <...> template tags.
  DisallowedSigns = begin 
    # Use concatenation (+) to work around Ruby bug!
    forbidden =  ' !"#' + "$%&'()*+,-./:;<=>?[\\]^`{|}~" 
    all_escaped = [] 
    forbidden.each_char { |ch| all_escaped << Regexp.escape(ch) }
    pattern = all_escaped.join('|')
    Regexp.new(pattern)
  end

  # The original text of the template is kept here.
  #attr_reader(:source)
  
  # The internal representation of the template text
  #attr_reader(:representation)
  
  # Builds an Engine and compiles the given template text into
  #  an internal representation.
  # @param aSourceTemplate [String] The template source text. 
  #   It may contain zero or tags enclosed between chevrons <...>.
  def initialize()
    #@source = aSourceTemplate
    #@representation = compile(aSourceTemplate)
  end

  public

  # Render the template within the given scope object and 
  # with the locals specified.
  # The method mimicks the signature of the Tilt::Template#render method.
  # @param aContextObject [anything] context object to get actual values
  #   (when not present in the locals Hash).
  # @param theLocals [Hash] Contains one or more pairs of the form:
  #   tag/placeholder name => actual value.
  # @return [String] The rendition of the template given 
  #  the passed argument values.
  def render(aContextObject = Object.new, theLocals)
    return '' if @representation.empty?

    prev = nil
    result = @representation.each_with_object('') do |element, subResult|
      # Output compaction rules:
      # -In case of consecutive eol's only one is rendered.
      # -In case of comment followed by one eol, both aren't rendered
      unless element.is_a?(EOLine) && 
        (prev.is_a?(EOLine) || prev.is_a?(Comment))
        subResult << element.render(aContextObject, theLocals)
      end
      prev = element
    end

    return result
  end

  
  # Retrieve all placeholder names that appear in the template.
  # @return [Array] The list of placeholder names.
  def variables()
    # The result will be cached/memoized...
    @variables ||= begin
      vars = @representation.each_with_object([]) do |element, subResult|
        case element
        when Placeholder          
          subResult << element.name
        
        else
          # Do nothing
        end
      end
      
      vars.flatten.uniq
    end
    
    return @variables
  end

  # Class method. Parse the given line text into a raw representation.
  # @return [Array] Couples of the form:
  # [:static, text], [:comment, text] or [:dynamic, tag text]
  def self.parse(aTextLine)
    scanner = StringScanner.new(aTextLine)
    result = []
    delimiter_found = false # Was a placeholder just detected?

    if scanner.check(/\s*#/)  # Detect comment line
      result << [:comment, aTextLine]
    else
      until scanner.eos?
        # Detect placeholder at current position...
        delimiter_found = scanner.check(/\{\{/)
        if delimiter_found
          placeholder = scanner.scan(/\{\{.*?\}\}/)
          unless placeholder.nil?
            result << [:dynamic, placeholder.gsub(/^\{\{|\}\}$/, '')]
          else
            # No closing accolades found
            identify_parse_error(aTextLine)
          end
        end
        
        # ... or scan plain text at current position
        literal = scanner.scan(/(?:[^{]|(?:\{(?!\{)))+/)
        if literal.nil?
          identify_parse_error(aTextLine)
        else
          result << [:static, literal] unless literal.nil? 
        end
      end
    end

    return result
  end
  
  def compile(aSourceTemplateText)
    # Compile into children template elements
    children = compile_source(aSourceTemplateText)
    return build_template(children)
  end

  private

  # Called when the given text line could not be parsed.
  # Raises an exception with the syntax issue identified.
  # @param aTextLine [String] A text line from the template.  
  def self.identify_parse_error(aTextLine)
    # Unsuccessful scanning: we typically have improperly balanced chevrons.
    # We will analyze the opening and closing chevrons...
     # First: replace escaped chevron(s)
    no_escaped = aTextLine.gsub(/\\[<>]/, '--')

    # var. equals count_of(<) -  count_of(>): can only be 0 or temporarily 1
    unbalance = 0

    no_escaped.each_char do |ch|
      case ch
      when '<' then unbalance += 1 
      when '>' then unbalance -= 1              
      end
      
      fail(StandardError, "Nested opening chevron '<'.") if unbalance > 1
      fail(StandardError, "Missing opening chevron '<'.") if unbalance < 0
    end
    
    fail(StandardError, "Missing closing chevron '>'.") if unbalance == 1 
  end
  
  
  # Create the internal representation of the given template.
  def compile_source(aSourceTemplate)
    # Split the input text into lines.
    input_lines = aSourceTemplate.split(/\r\n?|\n/)
    
    # Parse the input text into raw data.
    raw_lines = input_lines.map do |line| 
      line_items = self.class.parse(line)
      line_items.each do |(kind, text)|
        # A tag text cannot be empty nor blank
        if (kind == :dynamic) && text.strip.empty?
          fail(EmptyArgumentError.new(line.strip))
        end
      end
      
      line_items
    end
    
    compiled_lines = raw_lines.map { |line| compile_line(line) }
    return compiled_lines.flatten
  end
  
  
  # Convert the array of raw entries (per line) 
  # into full-fledged template elements.
  def compile_line(aRawLine)
    line_rep = aRawLine.map { |couple| compile_couple(couple) }
    
    # Apply the rule: when a line just consist of spaces 
    # and a section element, then remove all the spaces from that line.
    line_to_squeeze = line_rep.all? do |item|
      if item.kind_of?(StaticText)
        item.source =~ /\s+/
      else
        false
      end
    end
    line_rep_ending(line_rep) unless line_to_squeeze
    
    return line_rep
  end
  
  def build_template(theChildren)
    return Template.new(theChildren)
  end


  # Apply rule: if last item in line is an end of section marker, 
  # then place eoline before that item. 
  # Otherwise, end the line with a eoline marker.  
  def line_rep_ending(theLineRep)
    theLineRep << EOLine.new("\n") # TODO: replace this line
  end

  
  # @param aCouple [Array] a two-element array of the form: [kind, text]
  # Where kind must be one of :static, :dynamic
  def compile_couple(aCouple)
    (kind, text) = aCouple

    result = case kind
    when :static then StaticText.new(text)
    when :dynamic then parse_tag(text)
    end

    return result
  end


  # Parse the contents of a tag entry.
  # @param aText [String] The text that is enclosed between chevrons.
  def parse_tag(aText)
    # Recognize the first character
    if aText =~ /^[\?\/]/
      matching = DisallowedSigns.match(aText[1..-1])
    else
      # Disallow punctuation and delimiter signs in tags.
      matching = DisallowedSigns.match(aText)
    end
    fail(InvalidCharError.new(aText, matching[0])) if matching
    
    result = Placeholder.new(aText)

    return result
  end
 
end # class

#end # module

#end # module

# End of file
