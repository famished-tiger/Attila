# File: placeholder_spec.rb

#require_relative '../../spec_helper'
require_relative 'spec_helper'

# Load the classes under test
#require_relative '../../../lib/attila/templating/placeholder'
require_relative 'placeholder'

module Attila

module Templating # Open this namespace to get rid of module qualifier prefixes


describe Placeholder do
  # Default instantiation rule
  subject { Placeholder.new('foobar') }

  context 'Creation and initialization:' do

    it 'should be created with a variable name' do
      expect { Placeholder.new('foobar') }.not_to raise_error
    end

    it 'should know the name of its variable' do
      expect(subject.name).to eq('foobar')
    end

  end # context

  context 'Placeholder rendering:' do
  
    it 'should call the transformer while rendering itself' do
      context = double('context')
      converter = double('transformer')
      
      # Expected message sent by placeholder
      converter.should_receive(:transform).with(subject, context, 1)

      expect {subject.sub_render(converter, context, 1)}.not_to raise_error
    end
  end # context

end # describe

end # module

end # module

# End of file
