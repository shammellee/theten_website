'use strict'

_window = @

@CollectionNav = ->

$.extend @CollectionNav.prototype,
  _attributes:
    collection: null
    selector  : ''
    
  init: ->
    # do nothing if `_attributes.collection` is set
    return unless @_attributes.collection instanceof Collection

    $nav                  = @_attributes.$nav = $ @_attributes.selector
    $navLeft              = $nav.find '.collection_nav__left'
    $navRight             = $nav.find '.collection_nav__right'
    @$navInfoSingle       = $nav.find '.collection_nav_info__single'
    @$navInfoDouble       = $nav.find '.collection_nav_info__double'
    @$navInfoDoubleTop    = @$navInfoDouble.find '.topId'
    @$navInfoDoubleBottom = @$navInfoDouble.find '.bottomId'

    # CLICK EVENTS
    $navLeft.click $.proxy @_attributes.collection.prev, @_attributes.collection
    $navRight.click $.proxy @_attributes.collection.next, @_attributes.collection

    # KEY EVENTS
    $(_window.document).keydown (e) =>
      @_attributes.collection.prev(e) if e.which is 37
      @_attributes.collection.next(e) if e.which is 39

    # CUSTOM EVENT
    updateEvent = "#{@_attributes.collection.get('eventId')}:update"
    $(_window.document).on updateEvent, $.proxy @updateInfo, @

  set: (prop, val) ->
    return unless prop

    if typeof prop is 'object'
      $.extend @_attributes, prop
    else
      @_attributes[prop] = if val then val else null

    @

  updateInfo: (e, data) ->
    @$navInfoSingle.text ''
    @$navInfoDoubleTop.text ''
    @$navInfoDoubleBottom.text ''

    if data.topId and not data.bottomId
      @$navInfoDouble.hide()
      @$navInfoSingle.show()
      @$navInfoSingle.text data.topId

    if data.topId and data.bottomId
      @$navInfoSingle.hide()
      @$navInfoDouble.show()
      @$navInfoDoubleTop.text data.topId
      @$navInfoDoubleBottom.text data.bottomId

