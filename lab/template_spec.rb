# File: template_spec.rb


#require_relative '../../spec_helper'
require_relative 'spec_helper'

%w[static-text eo-line placeholder context 
   transformer engine].each do |file|
  #require_relative "../../../lib/attila/templating/#{file}"
  require_relative "#{file}"
end

# Load the class under test
#require_relative '../../../lib/attila/templating/template'
require_relative 'template'

module Attila # Open this namespace to get rid of module qualifier prefix

module Templating # Open this namespace to get rid of module qualifier prefix

describe Template do
  let(:sample_children) do
    prefix = StaticText.new('Hello ')
    placeholder = Placeholder.new('first_name')
    suffix = StaticText.new('!')

    [prefix, placeholder, suffix, EOLine.new("\r")]
  end

  # Variable assignments from context
  let(:scope) do
    { 'bye' => 'bye' }
  end

  # Variable assignments from local context
  let(:locals) do
    { 'first_name' => 'John', 'last_name' => 'Doe'}
  end

  let(:a_transformer) { Transformer.new }


  # Default instantiation rule
  subject { Template.new(sample_children) }


  context 'Creation & initialization:' do
    it 'should be created with children elements' do
      expect { Template.new(sample_children) }.not_to raise_error
    end

    it 'should know its children' do
      expect(subject.children).to eq(sample_children)
    end

    it 'should know that it is composite' do
      expect(subject).to be_composite
    end

    it 'should know that it is visitable (for rendering)' do
      dummy_context = double('dummy context')
      expect(subject).to be_visitable(dummy_context)
    end
    
    it 'should know its placeholders' do
      placeholders = subject.placeholders
      expect(placeholders).to have(1).items
      expect(placeholders[0]).to eq(sample_children[1])
    end

  end # context

  context 'Template rendering - part I:' do

    it 'should render a childless template' do
      instance = Template.new([])
      actual = instance.render(scope, locals, a_transformer, 2)
      expect(actual).to be_empty
    end

  end # context

  # Rely on Engine to build more complete template
  context 'Template rendering - part II:' do
  
  # Sample template (consisting of a sequence of steps)
    let(:sample_template) do
      source = <<-SNIPPET
  # This is a comment line
  Given I landed in the homepage
  And I fill in "Username" with "<userid>"
  And I fill in "Password" with "<password>"
  And I click "Sign in"
SNIPPET

      source
    end 
    
  end # context

end # describe

end # module

end # module

# End of file
