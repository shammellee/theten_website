'use strict'

@theTEN =
  $logo              : $('#logo_nav').find '.logo'
  $pageNav           : $('.nav__main').find '.nav_item_page'
  $pages             : $('#pages').find '.page'
  curPage            : $('.nav__main').find('.nav_item_page').filter('.selected').data 'page'

  init: ->
    # add click event listener to nav items and logo
    @$pageNav.add(@$logo).click (e) =>
      @setPage e.currentTarget.dataset.page

    # COLLECTION ZERO
    collectionZero = new Collection
    collectionZero.set
      collectionName: 'Collection Zero'
      onPage        : 'collection_zero'
      selector      : '#collection_zero_item_shell'
      uniqueId      : 'collectionZero'
    collectionZero.init()

    collectionZeroNav = new CollectionNav
    collectionZeroNav.set
      collection: collectionZero
      selector  : '.collection_zero_nav_shell'
    collectionZeroNav.init()

    # COLLECTION ONE
    collectionOne = new Collection
    collectionOne.set
      collectionName: 'Collection One'
      onPage        : 'collection_one'
      selector      : '#collection_one_item_shell'
      uniqueId      : 'collectionOne'
    collectionOne.init()

    collectionOneNav = new CollectionNav
    collectionOneNav.set
      collection: collectionOne
      selector  : '.collection_one_nav_shell'
    collectionOneNav.init()

  setPage: (page) ->
    # do nothing if already on page
    if @curPage is page
      return
    # otherwise, set current page to page parameter
    else
      @curPage = page
      $curPage = @$pages.filter "##{page}"

    #TweenMax.to($curPage, .15, {autoAlpha:0})
    # remove `selected` class from all nav items
    # then add `selected` class` to nav item with data-page value matching `page` parameter
    @$pageNav.removeClass('selected').filter("[data-page='#{page}']").addClass('selected')

    # remove `selected` class from all pages
    # then add `selected` class to page with id matching `page` parameter
    @$pages.removeClass('selected').filter("##{page}").addClass('selected')
    #TweenMax.to(@$pages.filter("#{page}")

@theTEN.init()

