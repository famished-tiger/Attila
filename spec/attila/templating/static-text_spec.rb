# File: static-text_spec.rb

require_relative '../../spec_helper'

# Load the class under test
require_relative '../../../lib/attila/templating/static-text'


module Attila # Open this namespace to get rid of module qualifier prefix

module Templating # Open this namespace to get rid of module qualifier prefixes

describe StaticText do
  let(:sample_text) { 'This is a sample text' }

  let(:multiline_text) do
    literal = <<-EOS
  # Sample multi-line text
  This
is a
  multi-
    line
  text
EOS
  end

  # Default instantiation rule
  subject { StaticText.new(sample_text) }

  context 'Creation & initialization:' do
    it 'should be created with a text literal' do
      # Case 1: empty text
      expect { StaticText.new('') }.not_to raise_error

      # Case 2: non-empty text
      expect { StaticText.new(sample_text) }.not_to raise_error
    end

    it 'should know its original representation' do
      # Case 1: empty text
      instance1 = StaticText.new('')
      expect(instance1.source).to be_empty

      # Case 2: non-empty text
      expect(subject.source).to eq(sample_text)

      # Case 3: multi-line text
      instance2 = StaticText.new(multiline_text)
      expect(instance2.source).to eq(multiline_text)
    end

  end # context


  context 'Text rendering:' do
    it 'should render the original text' do
      faked_context = double('context')
      faked_locals = double('locals')

      # Case 1: empty text
      instance1 = StaticText.new('')
      expect(instance1.render(faked_context, faked_locals)).to be_empty

      # Case 2: non-empty text
      expect(subject.render(faked_context, faked_locals)).to eq(sample_text)

      # Case 3: multi-line text
      instance2 = StaticText.new(multiline_text)
      expect(instance2.render(faked_context, faked_locals)).to eq(multiline_text)
    end
  end # context
end # describe

end # module

end # module