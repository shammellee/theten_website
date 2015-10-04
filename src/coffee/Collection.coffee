'use strict'

@Collection = ->
  @$currentItem     = null
  @currentItemIndex = 0
  @transitionSpeed  = .15
  @_attributes      =
    align         : 'right'
    $collection   : []
    collectionName: ''
    onPage        : ''
    selector      : ''
    uniqueId      : ''

  @

$.extend @Collection.prototype,
  attributes: ->
    @_attributes

  get: (prop) ->
    return unless prop

    @_attributes[prop]

  init: ->
    @_attributes.$collection = $(@_attributes.selector).children()
    $collection              = @_attributes.$collection
    @$currentItem            = $collection.first()

    @$currentItem.css({display:'initial', opacity:1, visibility:'visible'})
    $collection.addClass "collection_item collection_item__#{@_attributes.align}"

    @_attributes.$collection.each (i,el) ->
      $el = $ el

      $el.css 'background-image', "url(#{$el.data 'image'})"

  next: (e) ->
    TweenMax.to(@$currentItem, @transitionSpeed,
      opacity         : 0
      onComplete      : @$currentItem.css
      onCompleteParams: [{display:'none', visibility:'hidden'}]
      onCompleteScope : @
    )

    if @currentItemIndex >= @_attributes.$collection.length - 1
      @currentItemIndex = 0
    else
      @currentItemIndex++

    @$currentItem = @_attributes.$collection.eq @currentItemIndex

    @triggerUpdate()

    @$currentItem.css({display:'initial', opacity:0, visibility:'visible'})
    TweenMax.to(@$currentItem, @transitionSpeed, {opacity:1})

  prev: (e) ->
    TweenMax.to(@$currentItem, @transitionSpeed,
      opacity         : 0
      onComplete      : @$currentItem.css
      onCompleteParams: [{display:'none', visibility:'hidden'}]
      onCompleteScope : @
    )

    if @currentItemIndex <= 0
      @currentItemIndex = @_attributes.$collection.length - 1
    else
      @currentItemIndex--

    @$currentItem = @_attributes.$collection.eq @currentItemIndex
    data =
      topId: @$currentItem.data 'topId'
      bottomId: @$currentItem.data 'bottomId'

    updateEvent = "#{@_attributes.uniqueId}:update"
    $(window.document).trigger updateEvent, [data]

    @$currentItem.css({display:'initial', opacity:0, visibility:'visible'})
    TweenMax.to(@$currentItem, @transitionSpeed, {opacity:1})

  set: (prop, val) ->
    return unless prop

    if typeof prop is 'object'
      $.extend @_attributes, prop
    else
      @_attributes[prop] = if val then val else null

    @

  triggerUpdate: ->
    data =
      topId   : @$currentItem.data 'topId'
      bottomId: @$currentItem.data 'bottomId'

    updateEvent = "#{@_attributes.uniqueId}:update"
    $(window.document).trigger updateEvent, [data]

