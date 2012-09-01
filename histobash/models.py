from mongoengine import (DynamicDocument, StringField, ListField, DateTimeField, BooleanField,
                    IntField, ReferenceField)

from mongoengine.django.auth import User
from datetime import datetime


class Command(DynamicDocument):
    number = IntField(required=True)
    subject = StringField(required=True)
    command = StringField(required=True)
    command_position = IntField()
    comment = StringField()
    group = IntField(required=False)
    public = BooleanField()
    used_count = IntField()
    author = ReferenceField(User)
    tags = ListField()
    cdate = DateTimeField()
    mdate = DateTimeField()

    def save(self, *args, **kwargs):
        # trying to create a pull request for mongoengine to avoid this boilerplate:
        # https://github.com/hmarr/mongoengine
        # fork: https://github.com/asfaltboy/mongoengine
        if not self.cdate:
            self.cdate = datetime.now()
        self.mdate = datetime.now()
        return super(Command, self).save(*args, **kwargs)

    # Define permalink get_absolute_url link to /command/<alias>_<12345abcdf>
