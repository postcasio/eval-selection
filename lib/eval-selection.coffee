{ allowUnsafeEval } = require 'loophole'
coffee = require 'coffee-script'
util = require 'util'

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
    res

replaceSelectedText = (editor, cb) ->
  range = editor.getSelectedBufferRange()
  text = editor.getSelectedText()

  replacement = cb(text)
  editor.setTextInBufferRange range, replacement

module.exports =
  activate: (state) ->
    atom.workspaceView.eachEditorView (editorView) ->
      editorView.command 'eval-selection:eval-as-coffeescript', ->
        evalAsCoffeeScript(editorView.getEditor())
      editorView.command 'eval-selection:eval-as-javascript', ->
        evalAsJavaScript(editorView.getEditor())

  deactivate: ->
