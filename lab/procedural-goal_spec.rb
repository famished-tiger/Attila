require_relative 'spec_helper'

require 'ostruct'

require_relative 'step'
require_relative 'procedure'
require_relative 'procedural-goal'  # Load the class under test

describe ProceduralGoal do
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
  
  let(:sample_name) { 'enter_credentials' }
  
  let(:sample_statement) { 'enter the credentials {{userd_id}}, {{password}}' }
  
  let(:sample_procedure) do
    Procedure.new(sample_steps)
  end
  
  # Default instantiation rule
  subject { ProceduralGoal.new(sample_name, sample_statement, sample_procedure) }


  context 'Creation & initialization:' do
    it 'should be created with a name, a statement and a procedure' do
      expect {ProceduralGoal.new(sample_name, sample_statement, sample_procedure) }.not_to raise_error
    end
    
    it 'should know its name' do
      expect(subject.name).to eq(sample_name)
    end
    
    it 'should know its statement' do
      expect(subject.statement).to eq(sample_statement)
    end
    
    it 'should know its procedure' do
      expect(subject.procedure).to eq(sample_procedure)
    end    
  end # context
  
  context 'Provided services:' do
  end # context

end # describe

# End of file