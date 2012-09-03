from django.db.models import signals
from mongoengine import (DynamicDocument, StringField,
            ListField, DateTimeField, BooleanField,
            IntField, ReferenceField, Document)
from mongoengine.django.auth import User

import uuid
import hmac
from datetime import datetime
from hashlib import sha1


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


class ApiKey(Document):
    user = ReferenceField(User)
    key = StringField(max_length=255)
    created = DateTimeField(default=datetime.datetime.now)

    def __unicode__(self):
        return u"%s for %s" % (self.key, self.user)

    def save(self, *args, **kwargs):
        if not self.key:
            self.key = self.generate_key()

        return super(ApiKey, self).save(*args, **kwargs)

    def generate_key(self):
        # Get a random UUID.
        new_uuid = uuid.uuid4()
        # Hmac that beast.
        return hmac.new(str(new_uuid), digestmod=sha1).hexdigest()


def create_api_key(sender, **kwargs):
    """
    A signal for hooking up automatic ``ApiKey`` creation.
    """
    if kwargs.get('created') is True:
        ApiKey.objects.create(user=kwargs.get('instance'))

signals.post_save.connect(create_api_key, sender=User)
