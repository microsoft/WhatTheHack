import json


class ExampleModel:
    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__, sort_keys=False, indent=2)


class Biscuit(ExampleModel):
    def __init__(self, a, b):
        self.name = a
        self.address = b
        self.val = {'disk': a, 'disk_usage': b}


example = Biscuit('iSrael Ekpo', '34786')
example2 = ExampleModel()

print(example.toJSON())
