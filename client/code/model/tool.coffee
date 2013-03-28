class Cu.Model.Tool extends Backbone.RelationalModel
  Cu.Boxable.mixin this

  idAttribute: 'name'

  install: (callback) ->
    @_create_box().complete (ajaxObj, status) =>
      if status != 'success'
        callback ajaxObj, status
      else
        # Update ssh keys, quite hacky
        # TODO: remove when we have moved the box creation endpoint
        # into custard
        @_update_sshkeys()
        @exec("cd; rm -r http && git clone #{@get 'gitUrl'} tool --depth 1 && ln -s tool/http http").complete callback

  _update_sshkeys: ->
    $.ajax
      type: 'POST'
      url: "/api/#{window.user.effective.shortName}/sshkeys"
      data:
        key: null

Cu.Model.Tool.setup()

class Cu.Collection.Tools extends Backbone.Collection
  model: Cu.Model.Tool
  url: -> "/api/tools/"

  importers: ->
    importers = @filter (t) -> t.get('type') is 'importer'
    new Cu.Collection.Tools importers

  nonimporters: ->
    nonimporters = @filter (t) -> t.get('type') isnt 'importer'
    new Cu.Collection.Tools nonimporters

  basics: ->
    basics = @filter (t) ->
      t.get('name') in ['spreadsheet-download', 'datatables-view-tool']
    new Cu.Collection.Tools basics

  comparator: (model) ->
    model.get('manifest')?.displayName
