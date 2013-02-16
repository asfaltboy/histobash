# import local/prod settings to use the correct api/mongodb host/port conf.
try:
    from prod_settings import *
except ImportError:
    from local_settings import *
"""
The above needs to define at least the following:

# MongoDB configuration
MONGO_HOST = 'localhost'
MONGO_PORT = 3002
MONGO_USERNAME = 'user'
MONGO_PASSWORD = 'pass'

# API host configuration
SERVER_NAME = 'localhost:5000'

"""

MONGO_DBNAME = 'meteor'

RESOURCE_METHODS = ['GET', 'POST', 'DELETE']
ITEM_METHODS = ['GET', 'PATCH', 'DELETE']

CACHE_CONTROL = 'max-age=20'
CACHE_EXPIRES = 20

commands = {
    'schema': {
        'author': {
            'type': 'objectid',
            'required': True,
        },
        'title': {
            'type': 'string',
            'minlength': 1,
            'maxlength': 100,
            'required': True,
        },
        'command': {
            'type': 'string',
            'minlength': 1,
            'maxlength': 1000,
            'required': True,
        },
        'udate': {
            'type': 'datetime',
        },
        'cdate': {
            'type': 'datetime',
        },
        'mdate': {
            'type': 'datetime',
        },
        'comments': {
            'type': 'list',
        },
        'starred': {
            'type': 'integer',
        },
        'public': {
            'type': 'boolean',
        },
        'deleted': {
            'type': 'boolean',
        },
    }
}

users = {
    'additional_lookup': {
        'url': '[\w@.]+',
        'field': 'emails'
    },

    'schema': {
        'emails': {
            'type': 'list',
        },
    }
}

DOMAIN = {
    'users': users,
    'commands': commands,
}
