Commands = new Meteor.Collection('commands');

Commands.allow({
  insert: function (userId, command) {
    return false; // no cowboy inserts -- use createCommand method
  },
  update: function (userId, commands, fields, modifier) {
    return _.all(commands, function (command) {
      if (userId !== command.author)
        return false; // not the author

      var allowed = ["title", "command", "public"];
      if (_.difference(fields, allowed).length)
        return false; // tried to write to forbidden field
      return true;
    });
  },
  remove: function (userId, commands) {
    return ! _.any(commands, function (command) {
      // deny if not the author, or if other people are going
      return command.author !== userId;
    });
  }
});

Meteor.methods({
  // options should include: title, command, public
  createCommand: function (options) {
    options = options || {};
    if (!(typeof options.title === "string" && options.title.length &&
          typeof options.command === "string" && options.command.length))
      throw new Meteor.Error(400, "Required parameters missing");
    if (options.title.length > 100)
      throw new Meteor.Error(413, "Title too long");
    if (options.command.length > 1000)
      throw new Meteor.Error(413, "Command command too long");
    if (!this.userId)
      throw new Meteor.Error(403, "You must be logged in");

    return Commands.insert({
      author: this.userId,
      title: options.title,
      command: options.command,
      public: !! options.public,
      cdate: new Date(),
      mdate: new Date(),
      starred: 0,
      group: null,
      deleted: false,
      comments: [],
      tags: []
    });
  },
  deleteCommand: function (options) {
    if (!(typeof options.id === "string" && options.id.length))
      throw new Meteor.Error(400, "No command id given");
    if (!this.userId)
      throw new Meteor.Error(403, "You must be logged in");

    return Commands.update(options.id, {'$set': {deleted: true}});
  }
});

// Users
var displayName = function (user) {
  if (user.profile && user.profile.name)
    return user.profile.name;
  return user.emails[0].address;
};

var contactEmail = function (user) {
  if (user.emails && user.emails.length)
    return user.emails[0].address;
  if (user.services && user.services.facebook && user.services.facebook.email)
    return user.services.facebook.email;
  return null;
};