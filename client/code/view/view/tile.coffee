class Cu.View.ViewTile extends Backbone.View
  className: 'view'
  tagName: 'a'
  attributes: ->
    href: "/dataset/#{@model.get('plugsInTo').get('box')}/view/#{@model.get 'box'}"

  initialize: ->
    @model.on 'change', @render, this

  render: ->
    @$el.html JST['view-tile'] @model.toJSON()

    # :TODO: Make this suck less
    if /spreadsheet/i.test @model.get('name')
      @$el.addClass 'spreadsheet'
    if /download/i.test @model.get('name')
      @$el.addClass 'download'
    if /newdataset/i.test @model.get('name')
      @$el.addClass 'source'
    @
