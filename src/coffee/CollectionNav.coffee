'use strict'

@CollectionNav = ->

$.extend @CollectionNav.prototype,
  _attributes:
    collection: null
    selector  : ''
    
  init: ->
    # do nothing if `_attributes.collection` is set
    return unless @_attributes.collection instanceof Collection

    $nav      = @_attributes.$nav = $ @_attributes.selector
    $navLeft  = $nav.find '.collection_nav__left'
    $navRight = $nav.find '.collection_nav__right'

    # CLICK EVENTS
    $navLeft.click $.proxy @_attributes.collection.prev, @_attributes.collection
    $navRight.click $.proxy @_attributes.collection.next, @_attributes.collection

  set: (prop, val) ->
    return unless prop

    if typeof prop is 'object'
      $.extend @_attributes, prop
    else
      @_attributes[prop] = if val then val else null

    @

