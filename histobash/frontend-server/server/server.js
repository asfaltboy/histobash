// HistoBash server
Meteor.publish("directory", function () {
  return Meteor.users.find({}, {fields: {emails: 1, profile: 1}});
});

Meteor.publish("commands", function () {
  return Commands.find(
    {$or: [{public: true, deleted: false}, {author: this.userId, deleted: false}]});
});