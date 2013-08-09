module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    clean: {
      dev: ["build", "dist/dev"],
      prod: ["build", "dist/prod"]
    },
    emberTemplates: {
      compile: {
        options: {
          templateName: function(sourceFile) {
            return sourceFile.replace(/app\/templates\//, '')
          }
        },
        files: {
          'build/templates/templates.js': 'app/templates/**/*.handlebars'
        }
      }
    },
    coffee: {
      compile: {
        files: {
          'build/js/app.js': [
            'app/scripts/routes/*', 
            'app/scripts/controllers/*', 
            'app/scripts/views/*', 
            'app/scripts/helpers/*', 
            'app/scripts/data/*', 
            'app/scripts/models/*'
          ],
          'build/js/tests.js': [
            'ember-testing/tests/*'          
          ]
        }
      }
    },  
    sass:{
      dist: {
        files : {
          'build/compiled_sass.css': 'app/styles/app.sass'
        }
      }
    },
    cssmin: {
      compress: {
        files: {
          'build/prodcss/app.css': 'build/css/app.css'
        }
      }
    },
    uglify: {
      my_target: {
        files: {
          'build/js/app.js': ['build/js/app.js']
        }
      }
    },
    concat: {
      vendor: {
        src: [
          'bower_components/jquery/jquery.min.js',
          'app/bootstrap/js/bootstrap.min.js',
          'app/bootstrap/js/bootstrap-fileupload.min.js',
          'bower_components/handlebars/index.js',
          'bower_components/ember-dev/index.js',
          'bower_components/moment/index.js',
          'bower_components/md5/index.js',
          'bower_components/jquery-file-upload/js/vendor/jquery.ui.widget.js',
          'bower_components/jquery-file-upload/js/jquery.iframe-transport.js',
          'bower_components/jquery-file-upload/js/jquery.fileupload.js'
        ],
        dest: 'build/js/vendor.js'
      },
      prodVendor: {
        src: [
          'bower_components/jquery/jquery.min.js',
          'app/bootstrap/js/bootstrap.min.js',
          'app/bootstrap/js/bootstrap-fileupload.min.js',
          'bower_components/handlebars/index.js',
          'bower_components/ember/index.js',
          'bower_components/moment/index.js',
          'bower_components/md5/index.js',
          'bower_components/jquery-file-upload/js/vendor/jquery.ui.widget.js',
          'bower_components/jquery-file-upload/js/jquery.iframe-transport.js',
          'bower_components/jquery-file-upload/js/jquery.fileupload.js'
        ],
        dest: 'build/js/vendor.js'
      },
      app: {
        src: [
          'build/js/app.js',
          'build/templates/templates.js',
        ],
        dest: 'build/js/app.js'
      },
      prodApp: {
        src: [
          'build/js/app.js',
          'build/templates/templates.js',
        ],
        dest: 'build/js/app.js'
      },
      styles: {
        src: [
          'app/bootstrap/css/bootstrap.min.css',
          'app/bootstrap/css/bootstrap-responsive.min.css',
          'app/bootstrap/css/bootstrap-fileupload.min.css',
          'build/compiled_sass.css'
        ],
        dest: 'build/css/app.css'
      }
    },
    copy: {
      dev: {
        files: [
          {expand: true, cwd: "app/img", src: ['**'], dest: "dist/dev/img"},
          {expand: true, cwd: "app/fonts", src: ['**'], dest: "dist/dev/fonts"},
          {expand: true, cwd: "build/js", src: ['**'], dest: "dist/dev/js"},
          {expand: true, cwd: "build/css", src: ['**'], dest: "dist/dev/css"},
          {expand: true, cwd: "server", src: ['**'], dest: "dist/dev/server"},
          {src: ['index.html'], dest: "dist/dev/"},
          {src: ['favicon.ico'], dest: "dist/dev/"},
          {src: ['ember-testing/index.html'], dest: "dist/dev/"},
          {expand: true, cwd: "build/js", src: ['tests.js'], dest: "dist/dev/ember-testing/js"},
          {expand: true, cwd: "bower_components/qunit/qunit", src: ['**'], dest: "dist/dev/ember-testing/qunit"},
        ]
      },
      prod: {
        files: [
          {expand: true, cwd: "app/img", src: ['**'], dest: "dist/prod/img"},
          {expand: true, cwd: "app/fonts", src: ['**'], dest: "dist/prod/fonts"},
          {expand: true, cwd: "build/js", src: ['**'], dest: "dist/prod/js"},
          {expand: true, cwd: "build/prodcss", src: ['**'], dest: "dist/prod/css"},
          {expand: true, cwd: "server", src: ['**'], dest: "dist/prod/server"},
          {src: ['index.html'], dest: "dist/prod/"},
          {src: ['favicon.ico'], dest: "dist/prod/"}
        ]
      }
    },
    watch: {
      scripts: {
        files: 'app/**/*',
        tasks: ['compile']
      }
    }
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-ember-templates');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  express = require("express")
  
  grunt.registerTask('default', ['compile', 'webserver', 'watch']);
  grunt.registerTask('compile', ['clean:dev', 'emberTemplates', 'coffee', 'sass', 'concat:vendor', 'concat:app', 'concat:styles', 'copy:dev']);
  grunt.registerTask("webserver", "Start a custom static web server.", function(){
    grunt.log.writeln('Starting static web server');
    server = express();
    server.configure(function() {
      server.use("/", express["static"](__dirname + "/dist/dev"));
      server.get("*", function(req, res) {
        res.sendfile(__dirname + '/dist/dev/index.html');
      });
    });
    grunt.log.writeln('Listening on port 3000');
    server.listen(3000);
  });  
  grunt.registerTask('prod', ['clean:prod', 'emberTemplates', 'coffee', 'sass', 'concat:prodVendor', 'concat:prodApp', 'concat:styles', 'cssmin', 'uglify', 'copy:prod']);
};