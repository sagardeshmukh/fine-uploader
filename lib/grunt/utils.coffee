spawn = require('child_process').spawn
grunt = require 'grunt'

module.exports =

  checkPullRequest: ->
    if (process.env.TRAVIS_BRANCH == 'master' and process.env.TRAVIS_PULL_REQUEST != 'false')
      grunt.fail.fatal '''Woah there, buddy! Pull requests should be
      branched from develop!\n
      Details on contributing pull requests found here: \n
      https://github.com/Widen/fine-uploader/blob/master/CONTRIBUTING.md\n
      '''

  startKarma: (config, singleRun, done) ->
    browsers = grunt.option 'browsers'
    reporters = grunt.option 'reporters'
    port = grunt.option 'port'
    args = ['node_modules/karma/bin/karma', 'start', config,
      if singleRun then '--single-run=true' else '',
      if reporters then '--reporters=' + reporters else '',
      if browsers then '--browsers=' + browsers else '',
      if port then '--port=' + port else ''
    ]
    p = spawn 'node', args
    p.stdout.pipe process.stdout
    p.stderr.pipe process.stderr
    p.on 'exit', (code) ->
      if code != 0
        grunt.fail.warn "Karma test(s) failed. Exit code: " + code
      done()

  parallelTask: (args, options) ->
    task =
      grunt: true
      args: args
      stream: options && options.stream

    args.push '--port=' + @sauceLabsAvailablePorts.pop()

    if grunt.option 'reporters'
      args.push '--reporters=' + grunt.option 'reporters'

    task

  sauceLabsAvailablePorts: [9000, 9001, 9080, 9090, 9876]
