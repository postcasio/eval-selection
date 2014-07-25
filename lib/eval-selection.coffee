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
    coffee = require path.join atom.packages.resourcePath, 'node_modules', 'coffee-script'

    atom.workspaceView.eachEditorView (editorView) ->
      editorView.command 'eval-selection:eval-as-coffeescript', ->
        evalAsCoffeeScript(editorView.getEditor())
      editorView.command 'eval-selection:eval-as-javascript', ->
        evalAsJavaScript(editorView.getEditor())

  deactivate: ->
