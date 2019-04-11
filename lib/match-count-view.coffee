module.exports =
class MatchCountView
  constructor: ->
    @element = document.createElement('span')

    @activeItemSubscription = atom.workspace.onDidChangeActiveTextEditor => @subscribeToActiveTextEditor()

    @subscribeToActiveTextEditor()

  destroy: ->
    @activeItemSubscription.dispose()
    @selectionSubscription?.dispose()

  subscribeToActiveTextEditor: ->
    @selectionSubscription?.dispose()
    activeEditor = @getActiveTextEditor()
    selectionsMarkerLayer = activeEditor?.selectionsMarkerLayer
    @selectionSubscription = selectionsMarkerLayer?.onDidUpdate(@scheduleUpdateCount.bind(this))
    @scheduleUpdateCount()

  getActiveTextEditor: ->
    atom.workspace.getActiveTextEditor()

  scheduleUpdateCount: ->
    unless @scheduledUpdate
      @scheduledUpdate = true
      atom.views.updateDocument =>
        @updateCount()
        @scheduledUpdate = false

  updateCount: ->
    text = @getActiveTextEditor()?.getSelectedText()
    if text.length > 0
      count = @getActiveTextEditor()?.getSelectedBufferRanges().length
      if count == 1
        @element.textContent = count + ' match for ' + text
      else
        @element.textContent = count + ' matches for ' + text
     else
        @element.textContent = ''
