# File: eo-line_spec.rb

#require_relative '../../spec_helper'
require_relative 'spec_helper'

# Load the class under test
#require_relative '../../../lib/attila/templating/eo-line'
require_relative 'eo-line'

module Attila # Open this namespace to get rid of module qualifier prefix

module Templating # Open this namespace to get rid of module qualifier prefixes

describe EOLine do

  # Default instantiation rule
  subject { EOLine.new("\r") }

  context 'Creation & initialization:' do
    it 'should be created with a eol literal' do
      expect { EOLine.new("\n") }.not_to raise_error
    end

    it 'should know its original representation' do
      expect(subject.source).to eq("\r")
    end

  end # context


  context 'EOL rendering:' do
  
    it 'should call the transformer while rendering itself' do
      context = double('context')
      converter = double('transformer')
      
      # Expected message sent by eol
      converter.should_receive(:transform).with(subject, context, 1)

      expect {subject.sub_render(converter, context, 1)}.not_to raise_error
    end

  end # context 
end # describe

end # module

end # module