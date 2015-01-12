watch =
  find_service_name: ->
    url = location.href
    r = null
    if url.indexOf(NAVER_PLAYER_URL) isnt -1
      r = NAVER
    else if url.indexOf(BUGS_PLAYER_URL) isnt -1
      r = BUGS
    r

  on: (event, handler) ->
    @_handlers[event] = handler
    @

  trigger: (event, callback) ->
    if @_handlers[event] is undefined
      err = new Error "handler[#{ event }] not found"
      arguments_ = [err, null]
    else
      arguments_ = [null, @_handlers[event].apply(@, [])]
    if callback isnt undefined
      callback.apply @, arguments_

  _handlers: {}

  start: ->
    self = @
    @service = @find_service_name()
    if not @service
      throw new Error('cannot find music service')
    @trigger 'initialize', (err) ->
      if err
        console.log err.message
        throw err
      setInterval(
        ->
          self.tick.apply(self, [])
        , 1000
      )

  tick: ->
    self = @

###
#
    time = 0
    nowProgress = 0
    nowLen = ''
    thisService = ''
    f = ->
      that.tick.apply(self, [service, callback])
      true

    if this.isListen
      this.isListen = false

    switch service
      when BUGS
        thisService = this.BUGS_PREFIX
        nowProgress = jQuery('.progress .bar').attr('style').substr(7, 2)
        nowPlaying = jQuery('.nowPlaying').find('.trackInfo')
        if nowPlaying.length is 0
          setTimeout f, 1000
          return false
        else
          nowId = nowPlaying.attr('id')
          nowLen = nowPlaying.attr('duration')
          this.nowPlaying.id = nowId
          console.log 'nowProgress, ', nowProgress
      when this.NAVER_PREFIX
        thisService = this.NAVER_PREFIX
        $nowProgressBar = jQuery('.slider .play_value')

        if $nowProgressBar.length is 0
          setTimeout f, 1000
          return false
        else
          nowProgress = $nowProgressBar.attr('style').substr(7, 2)
          $nowPlayingTd = jQuery('.play_list_table tr.playing td.title')
          nowLen = jQuery('.progress .total_time').text()
          this.nowPlaying.id = $nowPlayingTd.attr('class').split(" ")[0].split(",")[1].split(":")[1]
      else
        this.isListen = false
        time = 100000
        return false

    [min, sec] = nowLen.split(":")
    min = parseInt min
    sec = parseInt sec
    this.nowPlaying.len = (sec + (min * 60)) * 1000
    if nowProgress.search('%') == 1 or nowProgress.search('p') == 1
      time = this.nowPlaying.len * 0.7
    else
      nowProgressInt = parseInt(nowProgress)
      time = this.nowPlaying.len * 0.05
      if not this.isListen and this.loggedAt <= nowProgressInt
        this.isListen = true
        remainPercentage = (100 - nowProgressInt) / 100
        remainTime = this.nowPlaying.len * (remainPercentage + 0.05)
        time = remainTime
        callback "#{thisService}#{this.EVENT_LISTEN}", this.nowPlaying.id
    if time isnt 0
      setTimeout(f, time)
    else
      setTimeout f, 10000
    this
###
