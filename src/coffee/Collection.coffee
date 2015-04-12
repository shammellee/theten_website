'use strict'

@Collection = ->
  @currentItemIndex = 0

  # return `false` so Collection.prototype is used
  false

$.extend @Collection.prototype,
  _attributes:
    align         : 'right'
    $collection   : []
    selector      : ''
    collectionName: ''

  attributes: ->
    @_attributes

  get: (prop) ->
    return unless prop

    @_attributes[prop]

  init: ->
    $collection = @_attributes.$collection = $(@_attributes.selector).children()
    $collection.hide().first().show()

    $collection.addClass "collection_item collection_item__#{@_attributes.align}"

    @_attributes.$collection.each (i,el) ->
      $el = $ el

      $el.css 'background-image', "url(#{$el.data 'image'})"

  next: (e) ->
    @_attributes.$collection.eq(@currentItemIndex).hide()

    if @currentItemIndex >= @_attributes.$collection.length - 1
      @currentItemIndex = 0
    else
      @currentItemIndex++

    @_attributes.$collection.eq(@currentItemIndex).show()

  prev: ->
    @_attributes.$collection.eq(@currentItemIndex).hide()

    if @currentItemIndex <= 0
      @currentItemIndex = @_attributes.$collection.length - 1
    else
      @currentItemIndex--

    @_attributes.$collection.eq(@currentItemIndex).show()

  set: (prop, val) ->
    return unless prop

    if typeof prop is 'object'
      $.extend @_attributes, prop
    else
      @_attributes[prop] = if val then val else null

    @

