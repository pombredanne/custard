child_process = require 'child_process'
fs = require 'fs'

mongoose = require 'mongoose'
Schema = mongoose.Schema

toolSchema = new Schema
  name: 
    type: String
    index: unique: true
  type: String
  gitUrl: String
  manifest: Schema.Types.Mixed

DbTool = mongoose.model 'Tool', toolSchema

class Tool
  constructor: (obj) ->
    for k of obj
      @[k] = obj[k]
    @

  save: (done) ->
    ds = new DbTool
      name: @name
      type: @type
      gitUrl: @gitUrl
      manifest: @manifest

    ds.save =>
      @id = ds._id
      done()

  gitClone: (options, callback) ->
    @directory = "#{options.dir}/#{@name}"
    child_process.exec "git clone #{@gitUrl} #{@directory}", callback

  loadManifest: (callback) ->
    fs.exists @directory, (isok) =>
      if not isok
        callback 'not cloned'
        return
      fs.readFile "#{@directory}/scraperwiki.json", (err, data) =>
        if err
          callback err
          return
        try
          @manifest = JSON.parse data
        catch error
          callback error: json: error
        callback null

  @findAll: (callback) ->
    DbTool.find {}, callback
  
  @findOneById: (id, callback) ->
    DbTool.findOne {_id: id}, callback

module.exports = (dbObj) ->
  DbTool = dbObj if dbObj?
  Tool