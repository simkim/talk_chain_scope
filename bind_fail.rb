# !/usr/bin/env ruby
# frozen_string_literal: true

# a basic model with a class method
class Person
  def self.hello
    puts 'Hello'
  end
end

class Relation
end

Person.method(:hello).unbind.bind(Relation).call
# in `bind': singleton method called for a different object (TypeError)

r = Relation.new
Person.method(:hello).unbind.bind(r).call
# in `bind': singleton method called for a different object (TypeError)
