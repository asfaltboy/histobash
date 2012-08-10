from tastypie import authorization
from tastypie_mongoengine import resources
from test_app import documents


# fields: email, password, social-auth

class PersonResource(resources.MongoEngineResource):
    class Meta:
        queryset = documents.Person.objects.all()
        allowed_methods = ('get', 'post', 'put', 'delete')
        authorization = authorization.Authorization()


class EmbeddedPersonResource(resources.MongoEngineResource):
    class Meta:
        object_class = documents.EmbeddedPerson


# fields: number, command, comment, subject

class CommandResource(resources.MongoEngineResource):
    class Meta:
        queryset = documents.Commands.objects.all()
        allowed_methods = ('get', 'post', 'put', 'delete')
        authorization = authorization.Authorization()


class EmbeddedCommandResource(resources.MongoEngineResource):
    class Meta:
        object_class = documents.EmbeddedPerson
