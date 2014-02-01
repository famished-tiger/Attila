require_relative 'spec_helper'

require 'ostruct' # Use OpenStruct instead of dumb 

require_relative 'step'

describe Step do
  let(:sample_args) do
    [ OpenStruct.new(name: 'foo'), 
      OpenStruct.new(name: 'bar'), 
      OpenStruct.new(name: 'some_text'),
      OpenStruct.new(name: 'some_locator')
    ]
  end
  
  let(:sample_snippet) do
    %Q|  When I fill in "{{some_locator}}" with "{{some_text}}\n|
  end
  
  let(:sample_guard) do
    sample_args.last
  end

  context 'Creation & initialization:' do
  
    subject do
      Step.new(sample_args, sample_snippet, sample_guard)
    end
    
    it "should complain if the guard isn't one of the step argument" do
      wrong = double('fake')
      wrong.should_receive(:name).and_return('wrong')
      
      err = StandardError
      err_msg = "Guard 'wrong' isn't a step argument."
      expect { Step.new(sample_args, sample_snippet, wrong) }.to raise_error(err, err_msg)
    end

    it 'should know its arguments' do
      expect(subject.arguments).to eq(sample_args)
    end

    it 'should know its snippet' do
      expect(subject.snippet).to be_kind_of(Template)
      expect(subject.snippet.source).to eq(sample_snippet)
    end

    it 'should know its guard' do
      # Case 1: guard variable is provided
      expect(subject.guard).to eq(sample_guard)
      
      # Case 2: no guard variable specified
      instance = Step.new(sample_args, sample_snippet, nil)
      expect(instance.guard).to be_nil      
    end
   
  end # context
end # describe