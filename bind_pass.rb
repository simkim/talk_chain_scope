
class Relation
    attr_reader :model, :conditions
    def initialize(model, conditions=[])
        @model = model
        @conditions = conditions
    end

    def where(arg)
        Relation.new(model, conditions + [arg])
    end

    def to_s
        "SELECT * FROM %s WHERE %s" % [self.model, self.conditions.join(" AND ")]
    end

    def scoping
        previous = Thread.current[model.name]
        Thread.current[model.name] = self
        yield
    ensure
        Thread.current[model.name] = previous
    end

    def method_missing(method, *args, &block)
        if model.respond_to?(method)
            scoping do
                model.send(method, *args, &block)
            end
        else
            super
        end
    end
end

class Model
    def self.relation
        Thread.current[self.name] || Relation.new(self)
    end
    def self.where(condition)
        relation.where(condition)
    end
end

class Person < Model
    def self.adult(age=18)
        where("age >= %d" % age)
    end
    def self.trained
        where("trained = true")
    end
end


puts Person.adult(21).trained
# SELECT * FROM Person WHERE age >= 21 AND trained = true
