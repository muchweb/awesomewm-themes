'use strict'

handlebars = require 'handlebars'
fs = require 'fs'

module.exports = class
    constructor: ->
        @template = null
        @themedata = null

    GetTemplate: (callback) ->
        return callback @template if @template?
        @LoadTemplate (data) =>
            callback data

    LoadTemplate: (callback) ->
        fs.readFile 'template/theme.lua',
            encoding: 'utf8'
        , (err, data) =>
            throw err if err
            @template = handlebars.compile data
            callback @template

    GetDefaultThemedata: (callback) ->
        return callback @themedata if @themedata?
        @LoadThemedata (data) =>
            @themedata = data
            callback data

    LoadThemedata: (callback, path='theme-data-default.json') ->
        fs.readFile path,
            encoding: 'utf8',
        , (err, data) =>
            throw err if err
            callback JSON.parse data

    ProcessThemedata: (callback, path) ->
        @GetDefaultThemedata (data_default) =>
            @LoadThemedata (data_loaded) ->
                # data_copy = data_default.splice()
                data_copy = data_default

                data_copy[key] = value for key, value of data_default
                callback data_copy
            , path

    GenerateThemeFile: (data, target) ->
        @GetTemplate (template) ->
            fs.writeFileSync target, (template data)

item = new module.exports
item.ProcessThemedata (data) ->
    item.GenerateThemeFile data, 'target.rc'
, 'themes/obscur.json'

console.log process.argv