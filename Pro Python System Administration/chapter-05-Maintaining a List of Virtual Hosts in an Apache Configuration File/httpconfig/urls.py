from django.conf.urls.defaults import *

urlpatterns = patterns('www_example_com.httpconfig.views',
    (r'^$', 'full_config'),
    (r'^(?P<object_id>\d+)/$', 'full_config'),
)
