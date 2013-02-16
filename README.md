HistoBash
=========

HistoBash is a lightweight combination of CLI and Cloud applications for storing your favorite shell command shortcuts locally and in the cloud.

A live example of the WebUI is available at: [histobash.herokuapp.com](http://histobash.herokuapp.com/)
An online API example is also coming soon.

If you're curious and wish to contribute, please do submit an issue/pull-request, don't limit yourself to a technology or langauge, we're in this for the ride :smile:

Current Architecture
--------------------

Currently we are using:
* MongoDB - the database
* Meteor - a node.js based web-ui frontend app
* Eve - A RESTful API HTTP server built on top of Flask as an abstraction wrapper to our DB
