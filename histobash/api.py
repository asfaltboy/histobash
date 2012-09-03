from tastypie.authorization import Authorization
from tastypie_mongoengine import resources, fields
from mongoengine.django.auth import User

from histobash.models import Command
from histobash.authentication import ApiKeyAuthentication


class UserResource(resources.MongoEngineResource):
    class Meta:
        queryset = User.objects.all()
        allowed_methods = ('get', 'post', 'put', 'delete')
        authentication = ApiKeyAuthentication
        authorization = Authorization()
        filtering = {
            "username": ('exact', ),
            "email": ('exact', ),
        }


# class EmbeddedUserResource(resources.MongoEngineResource):
#     class Meta:
#         object_class = EmbeddedPerson


# fields: number, command, comment, subject

class CommandResource(resources.MongoEngineResource):
    class Meta:
        queryset = Command.objects.all()
        allowed_methods = ('get', 'post', 'put', 'delete')
        authentication = ApiKeyAuthentication
        authorization = Authorization()

        filtering = {
            "subject": ('exact', ),
            "email": ('exact', ),
        }

    author = fields.ReferenceField(to=UserResource, attribute='author',
                                    full=False)


# class EmbeddedCommandResource(resources.MongoEngineResource):
#     class Meta:
#         object_class = EmbeddedPerson
