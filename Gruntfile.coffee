module.exports = (grunt) ->
  file_paths = ['*.coffee', '**/*.coffee']

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    coffee:
      # create content_script.js
      content:
        files:
          'content_script.js': [
            'content/util.coffee'
          ]
        options:
          join: true
          bare: true

      # compile all coffeescripts
      all:
        expand: true
        flatten: false
        cwd: ''
        src: file_paths
        ext: '.js'
        options:
          bare: true

    watch:
      scripts:
        files: file_paths
        tasks: ['coffee:content', 'coffee:all']
        options:
          delay: 0

  # Load grunt-contrib-*
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  # Register tasks
  grunt.registerTask 'livew', ['']
