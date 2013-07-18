App.ProjectController = Ember.ObjectController.extend
  uploadRole: null
  currentTime: 0
  progess: 0
  audition: (part) ->
    need = parseInt(part.id) - 1
    @content.needs[need].auditions.addObject {id: App.me.id, name: App.me.name, lastUpdated: new Date(), status: 'open'}
    @content.set 'lastUpdated', new Date()
    
    # update the user to participating in this project
    alreadythere = false
    p = App.me.content.get('participating')
    id = @content.id
    if p then p.forEach (p) -> 
      if p is id
        alreadythere = true 
    unless alreadythere
      if p then App.me.content.participating.push(id) else App.me.content.set('participating', [id])
      App.User.update()
    
    App.Project.update @content.id, App.Project.toJSON(@content)
  addOwnerFile: (f) ->
    file = App.File.create().setProperties(f)
    file.set('role', @content.get('uploadRole'))
    file.set('id', new Date().getTime())
    file.set('date', new Date())
    file.set('user', {id: App.me.get('id'), name: App.me.name})
    file.set('status', "accepted")
    files = @content.get('files')
    if files then @content.get('files').addObject(file) else @content.set('files', [file])
    @content.set 'lastUpdated', new Date()
    App.Project.update @content.id, App.Project.toJSON(@content)
    @content.set 'uploadRole', null
  completeSetup: ->
    @content.set 'status', 'open'
    App.Project.update @content.id, App.Project.toJSON(@content)
  pauseRoughMix: ->
    audio = $('.accepted-audio')[0].controller
    if audio
      @currentTime = audio.currentTime
      audio.pause() 
      $(".rough-mix-play-button").show()
      $(".rough-mix-pause-button").hide()     
  playRoughMix: ->
    audio = $('.accepted-audio')[0].controller
    console.log audio
    if audio
      console.log "play dammit!"
      # audio.currentTime = @currentTime or 0
      audio.play()
      $(".rough-mix-play-button").hide()
      $(".rough-mix-pause-button").show()
      @currentTime = 0
    else
      alert "There was an error trying to play the rough tracks. This only works in Chrome last I checked."
