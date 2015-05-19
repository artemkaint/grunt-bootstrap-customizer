#
# grunt-bootstrap-customizer
# http://gruntjs.com/
#
# Copyright (c) 2015 Artem Soltynsky
# Licensed under the MIT license.
#

'use strict'

bootstrapCustomizer = require 'bootstrap-customizer'
path = require 'path'
_ = require 'lodash'

module.exports = (grunt) ->
  grunt.registerMultiTask 'bootstrap_customizer', 'Compile Bootstrap css with overwritted variables from JSON', ->

    options = @options
      banner: ''
      variables: {}
      dest: null

    unless options.dest?
      grunt.log.error "Destination file for customize bootstrap is not set"
    else
      done = @async()
      dest = options.dest
      delete options.dest

      grunt.log.warn "Source files for customize bootstrap is not set" unless @files.length
      variables = {}

      @files.forEach (f) ->
        jsonVars = f.src.filter (filepath) ->
          # Warn on and remove invalid source files (if nonull was set).
          unless grunt.file.exists(filepath)
            not grunt.log.warn "Source file #{ filepath } not found."
          else
            true
        .map (filepath) ->
          # Read file source to vars object
          switch path.extname(filepath)
            when '.json'
              grunt.file.readJSON(filepath)
            when '.less'
              content = grunt.file.read filepath, encoding: 'utf8'
              lexemes = _.filter content.split('\n'), (item) -> item.trim()[0] is '@'
              result = {}
              for item in lexemes
                splitItems = item.split /[:;]/
                key = splitItems.shift().trim()
                value = splitItems.shift().trim()
                result[key] = value
              result
            else
              grunt.log.warn "Source file (#{ filepath }) of variables has unknown format"
              {}

        jsonVars.push(variables)
        variables = _.extend.apply(variables, jsonVars)

      variables = _.extend variables, options.variables ? {}

      bootstrapCustomizer _.extend(options, variables: variables), (content) ->
        grunt.file.write(dest, content)
        done()