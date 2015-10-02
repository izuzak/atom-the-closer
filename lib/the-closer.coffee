{Disposable, CompositeDisposable} = require 'atom'

hadNoPanes = false
disposables = null

module.exports =
  config:
    closeWindowTogetherWithLastTab:
      type: 'boolean'
      default: true

  activate: ->
    hadNoPanes = atom.workspace.getPanes().length == 1 and
       atom.workspace.getPanes()[0].getItems().length == 0

    disposables = new CompositeDisposable

    itemRemovedCallback = =>
      if atom.workspace.getPanes().length == 1 and
         atom.workspace.getPanes()[0].getItems().length == 0
        if atom.config.get('the-closer.closeWindowTogetherWithLastTab')
          atom.close()
        else
          process.nextTick => hadNoPanes = true

    disposables.add atom.workspace.onDidDestroyPaneItem itemRemovedCallback

    itemAddedCallback = =>
      hadNoPanes = false

    disposables.add atom.workspace.onDidAddPaneItem itemAddedCallback

    closedCallback = =>
      if hadNoPanes
        atom.close()

    window.addEventListener 'core:close', closedCallback
    disposables.add new Disposable ->
      window.removeEventListener 'core:close', closedCallback

  deactivate: ->
    disposables?.dispose()
