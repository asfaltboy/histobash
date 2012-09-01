from django.conf.urls import patterns, include, url
from django.contrib import admin

from histobash.api import CommandResource
from histobash.api import UserResource

from tastypie.api import Api

admin.autodiscover()

v1_api = Api(api_name='v1')
v1_api.register(CommandResource())
v1_api.register(UserResource())

urlpatterns = patterns('histobash',
    # administration
    url(r'^admin/', include(admin.site.urls)),

    # commands
    url(r'^command/$', 'views.new_command', name='new_command'),
    url(r'^command/(?P<id>)[0-9a-f-]{1,}$', 'views.edit_command', name='edit_command'),

    # api
    url(r'^api/', include(v1_api.urls)),

    # url(r'^histobash/', include('histobash.foo.urls')),
)
