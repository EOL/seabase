#!/usr/bin/env ruby

require_relative '../environment'

input = ARGF.read

puts input.gsub(%r|/../blast|, '/')
