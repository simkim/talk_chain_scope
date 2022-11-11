class Model:
    @classmethod
    def relation(self):
        return Relation(self)

    @classmethod
    def where(self, condition):
        return self.relation().where(condition)

class Relation:
    def __init__(self, model: Model, conditions: list = []):
        self.model = model
        self.conditions = conditions

    def where(self, condition):
        return Relation(self.model, self.conditions + [condition])

    def __str__(self):
        return "SELECT * FROM {} WHERE {}".format(self.model.__name__, " AND ".join(self.conditions))

    def __getattr__(self, attribute):
        # This is the magic : __func__ unbind the function from the class and bind it to the relation instance
        # It is not possible in ruby to bind a function to a different class than the one it is defined in
        # In this case, python is more message oriented than ruby
        return getattr(self.model, attribute).__func__.__get__(self, self.__class__)

class Person(Model):
    @classmethod
    def adult(self, age = 18):
       return self.where("age > {}".format(age))
    
    @classmethod
    def trained(self):
       return self.where("trained = true")

print(Person.adult(21).trained())
# SELECT * FROM Person WHERE age > 21 AND trained = true
