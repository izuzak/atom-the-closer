hadNoPanes = false

module.exports =
  config:
    closeWindowTogetherWithLastTab:
      type: 'boolean'
      default: true

  activate: ->
    hadNoPanes = atom.workspace.getEditors().length == 0

    atom.workspaceView.on 'pane:item-removed', =>
      if atom.workspace.getPanes().length == 1 and
         atom.workspace.getPanes()[0].getItems().length == 0
        if atom.config.get('the-closer.closeWindowTogetherWithLastTab')
          hadNoPanes = true
        else
          process.nextTick => hadNoPanes = true

    atom.workspaceView.on 'pane:item-added', =>
      hadNoPanes = false

    atom.workspaceView.on 'core:close', =>
      if hadNoPanes
        atom.close()
