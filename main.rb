# frozen_string_literal: true

if ENV['DEBUG']
  require 'pry'
  require 'prettyprint'
end

require_relative 'lib/truffle_pig'
