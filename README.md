HistoBash
=========

HistoBash is a lightweight combination of CLI and Cloud applications for storing your favorite shell command shortcuts locally and in the cloud.

Current Architecture
--------------------

Currently we are using:
* MongoDB - the database
* Meteor - a node.js based web-ui frontend app
* Eve - A RESTful API HTTP server built on top of Flask as an abstraction wrapper to our DB