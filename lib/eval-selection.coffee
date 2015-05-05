{CompositeDisposable} = require 'atom'
allowUnsafeEval = null
coffee = null
util = null

evalAsCoffeeScript = (editor) ->
  replaceSelectedText editor, (text) ->
    inspectResult allowUnsafeEval ->
      try
        coffee.eval text
      catch e
        e

evalAsJavaScript = (editor) ->
  replaceSelectedText editor, (text) ->
    inspectResult allowUnsafeEval ->
      try
        eval text
      catch e
        e

inspectResult = (res) ->
  if typeof res is 'object'
    util.inspect res
  else
    String(res)

replaceSelectedText = (editor, cb) ->
  range = editor.getSelectedBufferRange()
  text = editor.getSelectedText()

  replacement = cb(text)
  editor.setTextInBufferRange range, replacement

module.exports =
  activate: (state) ->
    util = require 'util'
    { allowUnsafeEval } = require 'loophole'
    path = require 'path'
    coffee = require 'coffee-script'
    @subs = new CompositeDisposable

    @subs.add atom.commands.add 'atom-workspace', 'eval-selection:eval-as-coffeescript', ->
      editor = atom.workspace.getActiveTextEditor()
      evalAsCoffeeScript(editor) if editor
    @subs.add atom.commands.add 'atom-workspace', 'eval-selection:eval-as-javascript', ->
      editor = atom.workspace.getActiveTextEditor()
      evalAsJavaScript(editor) if editor

  deactivate: ->
    @subs?.dispose()
