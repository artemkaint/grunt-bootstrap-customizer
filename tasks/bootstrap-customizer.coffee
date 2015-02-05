#
# grunt-bootstrap-customizer
# http://gruntjs.com/
#
# Copyright (c) 2015 Artem Soltynsky
# Licensed under the MIT license.
#

'use strict'

bootstrapCustomizer = require('bootstrap-customizer');

module.exports = (grunt) ->
  grunt.registerMultiTask 'bootstrap_customizer', 'Compile Bootstrap css with overwritted variables from JSON', ->

    options = @options
      banner: ''
      variables: {}
      dest: ''

    bootstrapCustomizer options, @async()