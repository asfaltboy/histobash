// Main content
Meteor.subscribe("directory");
Meteor.subscribe("commands");

Template.content.publicCommands = function() {
	return Commands.find({public: true});
}

Template.myCommands.commands = function() {
	return Commands.find({author: Meteor.userId()});
}

Template.content.displayName = function() {
  var author = Meteor.users.findOne(this.author);
  if (author._id === Meteor.userId())
    return "me";
  return displayName(author);
}

Template.content.events({
  'click .create': function (event, template) {
    if (!Meteor.userId()) // must be logged in to create commands
      return;
    Session.set("createError", null);
    Session.set("showCreateDialog", true);
  }
});

Template.myCommands.events({
  'click .delete': function (event, template) {
    if (!Meteor.userId()) // must be logged in to delete obviously
      return;
    Session.set("showDeleteDialog", true);
    Session.set("deletingCommandId", $(event.target).parents('tr').attr("rel"));
  },
  'click .edit': function (event, template) {
    if (!Meteor.userId()) // must be logged in to edit obviously
      return;
    Session.set("showEditDialog", true);
    Session.set("editingCommandId", $(event.target).parents('tr').attr("rel"));
  }
});

// dialog handling
Template.page.showDeleteDialog = function () {
  return Session.get("showDeleteDialog");
};

Template.page.showCreateDialog = function () {
  return Session.get("showCreateDialog");
};

Template.page.showEditDialog = function () {
  return Session.get("showEditDialog");
};

Template.createDialog.events({
  'click .save': function (event, template) {
    var title = template.find(".title").value;
    var command = template.find(".command").value;
    var public = !template.find(".private").checked;

    if (title.length && command.length) {
      Meteor.call('createCommand', {
        title: title,
        command: command,
        public: public
      });
      Session.set("showCreateDialog", false);
    } else {
      Session.set("createError",
                  "It needs a title and a command, please comply?");
    }
  },

  'click .cancel': function () {
    Session.set("showCreateDialog", false);
  }
});

Template.deleteDialog.events({
  'click .delete': function (event, template) {
    Meteor.call('deleteCommand', {
      id: Session.get("deletingCommandId")
    }, function (error, command) {
      if (!error) {
        // handle delete from collection here if required
      }
    });
    Session.set("showDeleteDialog", false);
  },

  'click .cancel': function () {
    Session.set("showDeleteDialog", false);
  }
});

Template.editDialog.editingCommand = function() {
  var cmd_id = Session.get("editingCommandId");
  if (!cmd_id) return;
  var cmd = Commands.findOne(cmd_id);
  if (!cmd) return;
  
  return {
    title: cmd.title,
    command: cmd.command,
    public: (cmd.public) ? "checked" : "",
    cdate: cmd.cdate,
    udate: cmd.udate,
    mdate: cmd.mdate,
    comments: cmd.comments
  };
};


Template.editDialog.events({
  'click .edit': function (event, template) {
    Meteor.call('editCommand', {
      id: Session.get("deletingCommandId")
    }, function (error, command) {
      if (!error) {
        // handle edited command
      }
    });
    Session.set("showEditDialog", false);
  },

  'click .cancel': function () {
    Session.set("showEditDialog", false);
  }
});

Template.createDialog.error = function () {
  return Session.get("createError");
};
