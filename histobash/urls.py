from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # administration
    url(r'^admin/', include(admin.site.urls)),

    # api
    # url(r'^$', 'histobash.views.home', name='home'),
    # url(r'^histobash/', include('histobash.foo.urls')),
)
