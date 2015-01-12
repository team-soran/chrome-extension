watch
  .on 'initialize', ->
    console.log 'my service', @service

  .on 'progress', (percentage) ->
    console.log @service, percentage

  .on 'change song', ->
    console.log 'abc'


watch.start()
