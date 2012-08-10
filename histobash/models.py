from mongoengine import (Document, StringField,
                    IntField, ReferenceField)


class Person(Document):
    email = StringField(required=True)
    first_name = StringField(max_length=50)
    last_name = StringField(max_length=50)


class Command(Document):
    number = IntField(required=True)
    command = StringField(required=True)
    comment = StringField()
    subject = StringField(required=True)
    author = ReferenceField(Person)
