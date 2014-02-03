require 'pp'
require_relative 'engine'

sample_text = 'begin {{some_tag}} }} end'
result = Engine.parse(sample_text)
pp result