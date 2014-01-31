# File: transformer_spec.rb

#require_relative '../../spec_helper'
require_relative 'spec_helper'


%w[static-text eo-line placeholder context].each do |file|
  #require_relative "../../../lib/attila/templating/#{file}"
  require_relative "#{file}"
end

# Load the class under test
#require_relative '../../../lib/attila/templating/transformer'
require_relative 'transformer'


#module Attila # Open this namespace to get rid of module qualifier prefix

#module Templating # Open this namespace to get rid of module qualifier prefixes

describe Transformer do
  let(:ctx) do
    Context.new({'foo' => 'oof', 'qux' => nil}, {'bar' => 'rab', 'baz' => nil})
  end

  # Default instantiation rule
  subject { Transformer.new(:crlf) }

  context 'Creation & initialization:' do
    it 'could be created without argument' do
      expect { Transformer.new }.not_to raise_error
    end

    it 'could be created with a eol mode' do
      Transformer::EOLRenderingModes.keys.each do |a_mode|
        expect { Transformer.new(a_mode) }.not_to raise_error
      end
    end

    it 'should reject unknown rendering mode' do
      err_type = StandardError
      err_msg = "Unsupported end of line rendering mode 'foobar'"
      expect { Transformer.new('foobar') }.to raise_error(err_type, err_msg)
    end

    it 'should know the end of line rendering mode' do
      Transformer::EOLRenderingModes.keys.each do |a_mode|
        instance = Transformer.new(a_mode)
        expect(instance.eol_rendering).to eq(a_mode)
      end
    end

  end # context


  context 'Eol rendering:' do
    def render_eol(an_instance, an_eol)
      an_instance.send(:transform_eo_line, an_eol, nil, nil)
    end

    it 'should render an eol according to its mode' do
      faked_eol = double('end of line')
      faked_eol.should_receive(:source).and_return("\r\n")

      # Case 1: 'as is' rendering
      instance = Transformer.new(:as_is)
      result = render_eol(instance, faked_eol)
      expect(result).to eq("\r\n")

      # Case 2: 'default' rendering
      instance2 = Transformer.new(:default)
      result = render_eol(instance2, faked_eol)
      expect(result).to eq($/)

      # Case 3: 'cr' rendering
      instance3 = Transformer.new(:cr)
      result = render_eol(instance3, faked_eol)
      expect(result).to eq("\r")

      # Case 4: 'crlf' rendering
      instance4 = Transformer.new(:crlf)
      result = render_eol(instance4, faked_eol)
      expect(result).to eq("\r\n")

      # Case 5: 'lf' rendering
      instance5 = Transformer.new(:lf)
      result = render_eol(instance5, faked_eol)
      expect(result).to eq("\n")
    end

  end # context

  context 'Placeholder rendering:' do

    def render_placeholder(an_instance, a_placeholder, a_context)
      an_instance.transform(a_placeholder, a_context, nil)
    end


    it 'should render an empty string when no actual value is absent' do

      # Case: context has no value associated to 'foobar'
      rendered_text = render_placeholder(subject, Placeholder.new('foobar'), ctx)
      expect(rendered_text).to be_empty

      # Case: locals Hash has a nil value associated to 'baz'
      rendered_text = render_placeholder(subject, Placeholder.new('baz'), ctx)
      expect(rendered_text).to be_empty

      # Case: context object has a nil value associated to 'qux'
      rendered_text = render_placeholder(subject, Placeholder.new('qux'), ctx)
      expect(rendered_text).to be_empty
    end


    it 'should render the actual value bound to the placeholder' do
      # Case: locals Hash has a value associated to 'bar'
      rendered_text = render_placeholder(subject, Placeholder.new('bar'), ctx)
      expect(rendered_text).to eq('rab')

      # Case: context object has a value associated to 'foo'
      rendered_text = render_placeholder(subject, Placeholder.new('foo'), ctx)
      expect(rendered_text).to eq('oof')

    end


  end # context


end # describe

#end # module

#end # module

# End of file
