# File: static-text_spec.rb

require_relative '../../spec_helper'

# Load the class under test
require_relative '../../../lib/attila/templating/eo-line'


module Attila # Open this namespace to get rid of module qualifier prefix

module Templating # Open this namespace to get rid of module qualifier prefixes

describe EOLine do

  # Default instantiation rule
  subject { EOLine.new("\r", :crlf) }

  context 'Creation & initialization:' do
    it 'should be created with a eol literal and mode' do
      EOLine::RenderingModes.keys.each do |a_mode|
        expect { EOLine.new("\n", a_mode) }.not_to raise_error
      end
    end
    
    it 'should reject unknown rendering mode' do
      err_type = StandardError
      err_msg = "Unsupported end of line rendering mode 'foobar'"
      expect { EOLine.new("\n", 'foobar') }.to raise_error(err_type, err_msg)    
    end

    it 'should know its original representation' do
      expect(subject.source).to eq("\r")
    end
    
    it 'should know its rendering mode' do
      EOLine::RenderingModes.keys.each do |a_mode|
        instance = EOLine.new("\n", a_mode) 
        expect(instance.rendering).to eq(a_mode)
      end
    end

  end # context


  context 'Text rendering:' do
    it 'should render an eol according to its mode' do
      faked_context = double('context')
      faked_locals = double('locals')

      # Case 1: 'as is' rendering
      instance1 = EOLine.new("\r\n", :as_is)
      expect(instance1.render(faked_context, faked_locals)).to eq("\r\n")
      
      # Case 2: 'default' rendering
      instance1 = EOLine.new("\r\n", :default)
      expect(instance1.render(faked_context, faked_locals)).to eq($/)
      
      # Case 3: 'cr' rendering
      instance1 = EOLine.new("\r\n", :cr)
      expect(instance1.render(faked_context, faked_locals)).to eq("\r")
      
      # Case 4: 'cr' + 'lf' rendering
      instance1 = EOLine.new("\r", :crlf)
      expect(instance1.render(faked_context, faked_locals)).to eq("\r\n")

      # Case 5: 'lf' rendering
      instance1 = EOLine.new("\r", :lf)
      expect(instance1.render(faked_context, faked_locals)).to eq("\n")
    end
  end # context
  
end # describe

end # module

end # module