{BufferedProcess} = require 'atom'
ProgressElement = require './progress-element'

module.exports =
  activate: ->
    atom.commands.add "atom-workspace", 'update-package-dependencies:update', =>
      @update()

  update: ->
    view = new ProgressElement
    view.displayLoading()
    panel = atom.workspace.addModalPanel(item: view)

    command = atom.packages.getApmPath()
    args = ['install']
    options = {cwd: @getActiveProjectPath()}

    exit = (code) ->
      view.element.focus()

      atom.commands.add view.element, 'core:cancel', ->
        panel.destroy()

      if code is 0
        view.displaySuccess()
      else
        view.displayFailure()

    @runBufferedProcess({command, args, exit, options})

  runBufferedProcess: (params) ->
    new BufferedProcess(params)

  getActiveProjectPath: ->
    if activeItemPath = atom.workspace.getActivePaneItem()?.getPath?()
      atom.project.relativizePath(activeItemPath)[0]
    else
      atom.project.getPaths()[0]
