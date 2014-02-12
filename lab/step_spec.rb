require_relative 'spec_helper'

require 'ostruct' # Use OpenStruct instead of dumb double

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

    it 'should know its arguments' do
      expect(subject.arguments).to eq(sample_args)
    end

    it 'should know its snippet' do
      expect(subject.snippet).to be_kind_of(Template)
      expect(subject.snippet.source).to eq(sample_snippet)
    end
    
    it "should complain if snippet uses a var that isn't one of the step argument" do
      a_snippet =  %Q|  When I fill in "{{baz}}" with "{{qux}}\n|
      err = StandardError
      msg = "Step snippet refers to 'baz' which isn't a step argument"
      expect { Step.new(sample_args, a_snippet, sample_guard)}.to raise_error(err, msg)
    end

    it 'should know its guard' do
      # Case 1: guard variable is provided
      expect(subject.guard).to eq(sample_guard)
      
      # Case 2: no guard variable specified
      instance = Step.new(sample_args, sample_snippet, nil)
      expect(instance.guard).to be_nil      
    end
    
    it "should complain if the guard isn't one of the step argument" do
      wrong = double('fake')
      wrong.should_receive(:name).and_return('wrong')
      
      err = StandardError
      err_msg = "Guard 'wrong' isn't a step argument."
      expect { Step.new(sample_args, sample_snippet, wrong) }.to raise_error(err, err_msg)
    end
   
  end # context
  
  context 'Snippet rendering:' do
    let(:sample_transformer) { Transformer.new(:crlf) }
    
    let(:sample_locals) do
      { 'foo' => 'id=foo', 'bar' => 'Hello world' }
      
    end
  
    let(:first_snippet) do
      %Q|  When I fill in "{{foo}}" with "{{bar}}"\n|
    end
  
    it 'should render its snippet in absence of guard' do
      step = Step.new(sample_args, first_snippet, nil)
      actual = step.render({},sample_locals, sample_transformer, 1)
      expected =  %Q|  When I fill in "id=foo" with "Hello world"\r\n|
      expect(actual).to eq(expected)
    end
    
    it 'should render its snippet when the guard has a value' do
      step = Step.new(sample_args, first_snippet, sample_guard)
      actual = step.render({'some_locator' => true}, sample_locals, sample_transformer, 1)
      expected =  %Q|  When I fill in "id=foo" with "Hello world"\r\n|
      expect(actual).to eq(expected)
    end
    
    it "should render an empty text when the guard isn't unassigned" do
      step = Step.new(sample_args, first_snippet, sample_guard)
      actual = step.render({'some_locator' => nil},sample_locals, sample_transformer, 1)
      expect(actual).to be_empty
    end

  end # context
end # describe