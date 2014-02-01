# File: context_spec.rb

#require_relative '../../spec_helper'
require_relative 'spec_helper'

# Load the class under test
require_relative 'context'
#require_relative '../../../lib/attila/templating/context'

module Attila

module Templating # Open this namespace to get rid of module qualifier prefixes


describe Context do
  let(:scope) do 
    { foo: 'scope foo', bar: 'scope bar' }
  end
  let(:locals) do 
    { bar: 'local bar', baz: 'local baz' }
  end

  # Default instantiation rule
  subject { Context.new(scope, locals) }

  context 'Creation and initialization:' do

    it 'should be created with a scope and locals arguments' do
      expect { Context.new(scope, locals) }.not_to raise_error
    end
    
    it 'should know its scope object' do
      expect(subject.scope).to eq(scope)
    end
    
    it 'should know its locals object' do
      expect(subject.locals).to eq(locals)
    end

  end # context

  context 'Value retrieval with Hash objects:' do
    it 'should retrieve a value from a local variable' do
      expect(subject[:baz]).to eq('local baz')
    end
    
    it 'should let local variable take precedence over scope variable' do
      expect(subject[:bar]).to eq('local bar')
    end
    
    it 'should retrieve a value from a scope variable' do
      expect(subject[:foo]).to eq('scope foo')
    end
  end # context


  context 'Value retrieval with Hash-like objects:' do
    it 'should retrieve a value from a local variable' do
      expect(subject[:baz]).to eq('local baz')
    end
    
    it 'should let local variable take precedence over scope variable' do
      expect(subject[:bar]).to eq('local bar')
    end
    
    it 'should retrieve a value from a scope variable' do
      expect(subject[:foo]).to eq('scope foo')
    end
  end # context
  
  context 'Value retrieval with named methods:' do
    class Foobar
      def foo() 'scope foo'; end
      def bar() 'scope bar'; end
    end # class
    
    it 'should retrieve a value from a local variable' do
      instance = Context.new(Foobar.new, locals)
      expect(subject[:baz]).to eq('local baz')
    end
    
    it 'should let local variable take precedence over scope variable' do
      expect(subject[:bar]).to eq('local bar')
    end
    
    it 'should retrieve a value from a scope variable' do
      expect(subject[:foo]).to eq('scope foo')
    end
  end # context

end # describe

end # module

end # module

# End of file