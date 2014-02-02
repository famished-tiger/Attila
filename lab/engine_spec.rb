# File: engine_spec.rb

#require_relative '../../spec_helper'
require_relative 'spec_helper'

# Load the class under test
# require_relative '../../../lib/attila/templating/engine'
require_relative 'engine'

module Attila

module Templating # Open this namespace to get rid of module qualifier prefixes


describe Engine do
  # Sample template (consisting of a sequence of steps)
  let(:sample_template) do
      source = <<-SNIPPET
  Given I landed in the homepage
  And I fill in "Username" with "{{userid}}"
  And I fill in "Password" with "{{password}}"
  And I click "Sign in"
SNIPPET

    source
  end



  # Rule for default instantiation
  subject { Engine.new sample_template }


  context 'Class services:' do
    # Helper method.
    # Remove enclosing accolades {{..}} (if any)
    def strip_accolades(aText)
      return aText.gsub(/^\{\{|\}\}$/, '')
    end

    it 'should parse an empty text line' do
      # Expectation: result should be an empty array.
      expect(Engine.parse('')).to be_empty
    end

    it 'should parse a text line without tag' do
      sample_text = 'Mary has a little lamb'
      result = Engine.parse(sample_text)

      # Expectation: an array with one couple:
      # [:static, the source text]
      expect(result).to have(1).items
      expect(result[0]).to eq([:static, sample_text])
    end

    it 'should parse a text line that consists of just a tag' do
      sample_text = '{{some_tag}}'
      result = Engine.parse(sample_text)

      # Expectation: an array with one couple:
      # [:static, the source text]
      expect(result).to have(1).items
      expect(result[0]).to eq([:dynamic, strip_accolades(sample_text)])
    end

    it 'should parse a text line with a tag at the start' do
      sample_text = '{{some_tag}}some text'
      result = Engine.parse(sample_text)

      # Expectation: an array with two couples:
      # [dynamic, 'some_tag'][:static, some text]
      expect(result).to have(2).items
      expect(result[0]).to eq([:dynamic, 'some_tag'])
      expect(result[1]).to eq([:static,  'some text'])
    end

    it 'should parse a text line with a tag at the end' do
      sample_text = 'some text{{some_tag}}'
      result = Engine.parse(sample_text)

      # Expectation: an array with two couples:
      # [:static, some text] [dynamic, 'some_tag']
      expect(result).to have(2).items
      expect(result[0]).to eq([:static,  'some text'])
      expect(result[1]).to eq([:dynamic, 'some_tag'])
    end

    it 'should parse a text line with a tag in the middle' do
      sample_text = 'begin {{some_tag}} end'
      result = Engine.parse(sample_text)

      # Expectation: an array with three couples:
      expect(result).to have(3).items
      expect(result[0]).to eq([:static,  'begin '])
      expect(result[1]).to eq([:dynamic, 'some_tag'])
      expect(result[2]).to eq([:static,  ' end'])
    end

    it 'should parse a text line with two placeholders in the middle' do
      sample_text = 'begin {{some_tag}}middle{{another_tag}} end'
      result = Engine.parse(sample_text)

      # Expectation: an array with items couples:
      expect(result).to have(5).items
      expect(result[0]).to eq([:static ,  'begin '])
      expect(result[1]).to eq([:dynamic, 'some_tag'])
      expect(result[2]).to eq([:static , 'middle'])
      expect(result[3]).to eq([:dynamic, 'another_tag'])
      expect(result[4]).to eq([:static,  ' end'])

      # Case: two consecutive placeholders
      sample_text = 'begin {{some_tag}}{{another_tag}} end'
      result = Engine.parse(sample_text)

      # Expectation: an array with four couples:
      expect(result).to have(4).items
      expect(result[0]).to eq([:static,  'begin '])
      expect(result[1]).to eq([:dynamic, 'some_tag'])
      expect(result[2]).to eq([:dynamic, 'another_tag'])
      expect(result[3]).to eq([:static,  ' end'])
    end
=begin
    it 'should parse a text line with escaped chevrons' do
      sample_text = 'Mary has a {{\{little}}\} lamb'
      result = Engine.parse(sample_text)

      # Expectation: an array with one couple: [:static, the source text]
      pp result
      expect(result).to have(1).items
      expect(result[0]).to eq([:static, sample_text])
    end
=end
=begin
    it 'should parse a text line with escaped accolades in a tag' do
      sample_text = 'begin {{some_\{\\>weird\>_tag}} end'
      result = Engine.parse(sample_text)

      # Expectation: an array with three couples:
      expect(result).to have(3).items
      expect(result[0]).to eq([:static,  'begin '])
      expect(result[1]).to eq([:dynamic, 'some_\<\\>weird\>_tag'])
      expect(result[2]).to eq([:static,  ' end'])
    end
=end
    it 'should complain if a placeholder misses two closing accolades' do
      sample_text = 'begin {{some_tag end'
      error_message = "Missing closing chevron '>'."
      expect { Engine.parse(sample_text) }.to raise_error(
        StandardError, error_message)
    end

    it  'should complain if a text misses an opening chevron' do
      sample_text = 'begin <some_tag> > end'
      error_message = "Missing opening chevron '<'."
      expect { Engine.parse(sample_text) }.to raise_error(
        StandardError, error_message)
    end

    it  'should complain if a text has nested opening chevrons' do
      sample_text = 'begin <<some_tag> > end'
      error_message = "Nested opening chevron '<'."
      expect { Engine.parse(sample_text) }.to raise_error(
        StandardError, error_message)
    end

  end # context

  context 'Creation and initialization:' do
  
    it 'should be created withour parameters' do
      expect { Engine.new() }.not_to raise_error
    end
  
  end # context
  
  context 'Template compilation:' do
    # Default instantiation rule
    subject { Engine.new }

    it 'should compile an empty template source text' do
      template = subject.compile ''
      expect(template).to be_kind_of(Template)
      expect(template.children).to be_empty
    end
    
    it 'should compile a non-empty template text' do
      template = subject.compile(sample_template)
      expect(template).to be_kind_of(Template)
    end
    
    it 'should complain when a placeholder is empty or blank' do
      text_w_empty_arg = sample_template.sub(/userid/, '')
      msg = 'An empty or blank argument occurred in ' +
        %Q('And I fill in "Username" with "<>"'.)
      expect {subject.compile text_w_empty_arg }.to raise_error(
        EmptyArgumentError, msg)
    end
    
    it 'should complain when a placeholder contains an invalid character' do
      text_w_empty_arg = sample_template.sub(/userid/, 'user%id')
      msg = "The invalid sign '%' occurs in the argument 'user%id'."
      expect { subject.compile text_w_empty_arg }.to raise_error(
        InvalidCharError, msg)
    end
    

  end # context

end # describe

end # module

end # module

# End of file
