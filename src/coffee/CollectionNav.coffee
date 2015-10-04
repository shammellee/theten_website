'use strict'

_window = @

@CollectionNav = ->
  @_attributes =
    collection: null
    selector  : ''
  @

$.extend @CollectionNav.prototype,
  init: ->
    # noop if `_attributes.collection` is not of type Collection
    return unless @_attributes.collection instanceof Collection

    @_attributes.$nav     = $ @_attributes.selector
    $nav                  = @_attributes.$nav
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
      if _window.theTEN.curPage is @_attributes.collection._attributes.onPage
        @_attributes.collection.prev(e) if e.which is 37
        @_attributes.collection.next(e) if e.which is 39

    # CUSTOM EVENT
    updateEvent = "#{@_attributes.collection.get('uniqueId')}:update"
    $(_window.document).on updateEvent, $.proxy @updateInfo, @

    @_attributes.collection.triggerUpdate()

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

