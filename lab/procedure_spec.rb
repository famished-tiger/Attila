require_relative 'spec_helper'

require 'ostruct' # Use OpenStruct instead of dumb double

require_relative 'transformer'
require_relative 'step'
require_relative 'procedure'

describe Procedure do
  let(:sample_args1) do
    [ OpenStruct.new(name: 'user_id'),  
      OpenStruct.new(name: 'textbox_user_id'),
    ]
  end
  
  let(:sample_args2) do
    [ OpenStruct.new(name: 'password'), 
      OpenStruct.new(name: 'textbox_password')
    ]
  end
  
  let(:snippet1) do
    %Q|  When I fill in "{{textbox_user_id}}" with "{{user_id}}"\n|
  end
  
  let(:snippet2) do
    %Q|  When I fill in "{{textbox_password}}" with "{{password}}"\n|
  end
  
  let(:sample_steps) do
    step1 = Step.new(sample_args1, snippet1, sample_args1[0])
    step2 = Step.new(sample_args2, snippet2, sample_args2[0])
    
    [step1, step2]
  end
  
  # Default instantiation rule
  subject { Procedure.new(sample_steps) }

  context 'Creation & initialization:' do

    it 'should be created with steps' do
      expect {Procedure.new(sample_steps)}.not_to raise_error
    end
    
    it 'should know its steps' do
      expect(subject.steps).to eq(sample_steps)
    end
    
    it 'should know the test variables it depends on' do
      expected = [sample_args1, sample_args2].flatten
      
      expect(subject.dependencies).to eq(expected)
    end
  end # context
  
  context 'Rendering:' do
    it 'should render no step when no guard is fulfilled' do
      xformer = double('fake-transformer')
      expect(subject.render({}, {}, xformer, 1)).to be_empty
    end
    
    it 'should render all the steps when all the guards are fulfilled' do
      xformer = Transformer.new
      assignments = { 'user_id' => 'jdoe', 'password' => 'unguessable'}
      expected = <<-SNIPPET
  When I fill in "" with "jdoe"
  When I fill in "" with "unguessable"
SNIPPET
      expect(subject.render({}, assignments, xformer, 1)).to eq(expected)    
    end
  end
end # describe

# End of file
