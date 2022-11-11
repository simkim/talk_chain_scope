
#!/usr/bin/env ruby

class Person
    def self.hello
        puts "Hello"
    end
end

class Relation
end

r = Relation.new
Person.method(:hello).unbind.bind(Relation).call
# in `bind': singleton method called for a different object (TypeError)


Person.method(:hello).unbind.bind(r).call
# in `bind': singleton method called for a different object (TypeError)
