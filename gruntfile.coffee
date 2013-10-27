module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    meta:
      build   : 'build',
      assets  : 'app/assets',
      banner  : '/* <%= pkg.name %> v<%= pkg.version %> - <%= grunt.template.today("yyyy/m/d") %>\n' +
              '   <%= pkg.homepage %>\n' +
              '   Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>' +
              ' - Licensed <%= _.pluck(pkg.license, "type").join(", ") %> */\n'

    source:
      coffee: [
        'monocle/models/*.coffee'
        'monocle/views/*.coffee'
        'monocle/controllers/*.coffee']
      stylus: [
        'stylesheets/theme.*.styl'
        'stylesheets/app.*.styl']

    components:
      js: [
        'bower_components/quojs/quo.js'
        'bower_components/lungo/lungo.js'
        'bower_components/monocle/monocle.js'
        'bower_components/appnima.js/appnima.js'
        'bower_components/hope/hope.js'
        'bower_components/device.js/device.js']
      css: [
        'bower_components/lungo/lungo.css'
        'bower_components/lungo/lungo.icon.css']


    concat:
      coffee: files: '<%=meta.build%>/<%=pkg.name%>.debug.coffee'       : '<%= source.coffee %>'
      js    : files: '<%=meta.assets%>/js/<%=pkg.name%>.components.js'  : '<%= components.js %>'
      css   : files: '<%=meta.assets%>/css/<%=pkg.name%>.components.css': '<%= components.css %>'


    coffee:
      app: files: '<%=meta.build%>/<%=pkg.name%>.debug.js' : '<%=meta.build%>/<%=pkg.name%>.debug.coffee'


    uglify:
      options: report: "gzip", mangle: false, banner: "<%= meta.banner %>"
      coffee: files: '<%=meta.assets%>/js/<%=pkg.name%>.js': '<%=meta.build%>/<%=pkg.name%>.debug.js'


    stylus:
      app:
        options: compress: true, import: [ '__init']
        files: '<%=meta.assets%>/css/<%=pkg.name%>.css': '<%=source.stylus%>'


    watch:
      coffee:
        files: ['<%= source.coffee %>']
        tasks: ['concat:coffee', 'coffee:app', 'uglify:coffee']
      stylus:
        files: ['<%= source.stylus %>']
        tasks: ['stylus']


  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['concat', 'coffee', 'uglify', 'stylus']
