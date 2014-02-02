require 'pp'
require_relative 'engine'

sample_text = 'Mary has a {{little lamb'
result = Engine.parse(sample_text)
pp result