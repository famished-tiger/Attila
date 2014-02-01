# File: template-visitor_spec.rb

#require_relative '../../spec_helper'
require_relative 'spec_helper'

%w[static-text eo-line placeholder context template].each do |file|
  #require_relative "../../../lib/attila/templating/#{file}"
  require_relative "#{file}"
end

# Load the class under test
#require_relative '../../../lib/attila/templating/template-visitor'
require_relative 'template-visitor'

module Attila

module Templating # Open this namespace to get rid of module qualifier prefixes


describe TemplateVisitor do
  let(:scope) do
    { 'bye' => 'bye' }
  end
  let(:locals) do
    { }
  end

  # Default context object
  let(:a_context) { Context.new(scope, locals) }

  context 'Enumerator factory:' do

    it 'should create an enumerator' do
      template = double('fake-template')
      expect { TemplateVisitor.build(template, a_context, 1)}.not_to raise_error

      visitor = TemplateVisitor.build(template, a_context, 1)
      expect(visitor).to be_kind_of(Enumerator)
    end

  end # context

  context 'Template visiting:' do

    it 'should visit an empty template' do
      template = Template.new([])
      instance = TemplateVisitor.build(template, a_context, 1)

      # Template itself is first visited item
      expected_events = [ 
        [:visit, template, 1], 
        [:before_children, template, 1, 0],
        [:after_children, template, 1]
      ]
      expect(instance.to_a).to eq(expected_events)
    end

    it 'should visit a flat template' do
      prefix = StaticText.new('Hello ')
      suffix = StaticText.new('!')
      placeholder = Placeholder.new('name')

      template = Template.new([prefix, placeholder, suffix])
      instance = TemplateVisitor.build(template, a_context, 1)

      expected_events = [ 
        [:visit, template, 1],
        [:before_children, template, 1, 3],
        [:visit, prefix, 2], 
        [:visit, placeholder, 2], 
        [:visit, suffix, 2],
        [:after_children, template, 1],
      ]
      # Visited items
      expect(instance.to_a).to eq(expected_events)
    end
    

  end # context

end # describe

end # module

end # module

# End of file