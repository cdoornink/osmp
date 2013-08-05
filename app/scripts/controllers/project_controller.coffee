App.ProjectController = Ember.ObjectController.extend
  uploadRole: null
  currentTime: 0
  progess: 0
  update: -> 
    @content.set 'lastUpdated', new Date()
    App.Project.update @content.id, App.Project.toJSON(@content)
  setReadyToMix: ->
    @content.set 'status', "TracksComplete"    
    mix = App.Mix.create().setProperties({status: 'open'})
    @content.set 'mix', mix
    @update()
  acceptMix: (acceptingAudition) ->
    auditions = []
    files = []
    file_id = null
    @content.mix.auditions.forEach (a) -> 
      audition = App.Audition.create().setProperties(a)
      if audition.get('id') is acceptingAudition.id
        audition.set 'status', "accepted"
        audition.set 'lastUpdated', new Date()
        file_id = audition.get('file')
      auditions.addObject(audition)
    @content.mix.set('auditions', auditions)
    if file_id
      @content.get('files').forEach (f) ->
        file = App.File.create().setProperties(f)
        if file.id is file_id
          file.set('status', 'acceptedMix')
        files.addObject(file)  
      @content.set 'files', files
    @content.mix.set 'status', 'closed'
    @content.set 'status', "closed"
    @update()
  rejectMix: (rejectingAudition) ->
    auditions = []
    files = []
    file_id = null
    @content.mix.auditions.forEach (a) -> 
      audition = App.Audition.create().setProperties(a)
      if audition.get('id') is rejectingAudition.id
        audition.set 'status', "rejected"
        audition.set 'lastUpdated', new Date()
        file_id = audition.get('file')
      auditions.addObject(audition)
    @content.mix.set('auditions', auditions)
    if file_id
      @content.get('files').forEach (f) ->
        file = App.File.create().setProperties(f)
        if file.id is file_id
          file.set('status', 'rejectedMix')
        files.addObject(file)  
      @content.set 'files', files
    @update()
  auditionMix: ->
    unless App.me.content.firstName
      alert 'You must sign in to audition for this part'
      return
    @content.mix.auditions.addObject {id: App.me.id, name: App.me.name, lastUpdated: new Date(), status: 'open'}   
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
    @update()
  audition: (part) ->
    unless App.me.content.firstName
      alert 'You must sign in to audition for this part'
      return
    need = parseInt(part.id) - 1
    @content.needs[need].auditions.addObject {id: App.me.id, name: App.me.name, lastUpdated: new Date(), status: 'open'}
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
    @update()
  addOwnerFile: (f) ->
    file = App.File.create().setProperties(f)
    file.set('role', @content.get('uploadRole'))
    file.set('id', new Date().getTime())
    file.set('date', new Date())
    file.set('user', {id: App.me.get('id'), name: App.me.name})
    file.set('status', "accepted")
    files = @content.get('files')
    if files then @content.get('files').addObject(file) else @content.set('files', [file])
    @update()
    @content.set 'uploadRole', null
  addAuditionerFile: (f, p) ->
    id = new Date().getTime()
    need = parseInt(p.id) - 1
    auditions = []
    @content.needs[need].auditions.forEach (a) -> 
      audition = App.Audition.create().setProperties(a)
      if audition.get('id') is App.me.get('id')
        audition.set 'status', 'submitted'
        audition.set 'file', id
        audition.set 'lastUpdated', new Date()
        a = audition
      auditions.addObject(audition)
    @content.needs[need].set('auditions', auditions)
    file = App.File.create().setProperties(f)
    file.set('role', p.get('role'))
    file.set('id', id)
    file.set('date', new Date())
    file.set('user', {id: App.me.get('id'), name: App.me.name})
    file.set('status', "submitted")
    file.set('need', p.get('id'))
    files = @content.get('files')
    if files then @content.get('files').addObject(file) else @content.set('files', [file])
    @content.set 'lastUpdated', new Date()
    @update()
  addMixFile: (f) ->
    id = new Date().getTime()
    auditions = []
    @content.mix.auditions.forEach (a) -> 
      audition = App.Audition.create().setProperties(a)
      if audition.get('id') is App.me.get('id')
        audition.set 'status', 'submitted'
        audition.set 'file', id
        audition.set 'lastUpdated', new Date()
        a = audition
      auditions.addObject(audition)
    @content.mix.set('auditions', auditions)
    file = App.File.create().setProperties(f)
    file.set('role', "mixing")
    file.set('id', id)
    file.set('date', new Date())
    file.set('user', {id: App.me.get('id'), name: App.me.name})
    file.set('status', "submittedMix")
    files = @content.get('files')
    if files then @content.get('files').addObject(file) else @content.set('files', [file])
    @content.set 'lastUpdated', new Date()
    @update()
  completeSetup: ->
    @content.set 'status', 'open'
    @update()
  deleteAudio: (df) ->
    files = []
    @content.get('files').forEach (f) ->
      file = App.File.create().setProperties(f)
      unless file.id is df.id
        files.addObject(file)  
    @content.set 'files', files
    @update()
    #should actually delete the real file before the reference to it
  deleteAuditionAudio: (p, deletingAudition) ->
    need = parseInt(p.id) - 1
    auditions = []
    files = []
    @content.get('files').forEach (f) ->
      file = App.File.create().setProperties(f)
      unless file.id is deletingAudition.file
        files.addObject(file)  
    @content.set 'files', files
    @content.needs[need].auditions.forEach (a) -> 
      audition = App.Audition.create().setProperties(a)
      if audition.get('id') is deletingAudition.get('id')
        audition.set 'status', 'open'
        audition.set 'file', null
        audition.set 'lastUpdated', new Date()
      auditions.addObject(audition)
    @content.needs[need].set('auditions', auditions)
    @update()
    #should actually delete the real file before the reference to it
  changeAuditionStatus: (p, acceptingAudition, status) ->
    need = parseInt(p.id) - 1
    auditions = []
    files = []
    file_id = null
    @content.needs[need].auditions.forEach (a) -> 
      audition = App.Audition.create().setProperties(a)
      if audition.get('id') is acceptingAudition.id
        audition.set 'status', status
        audition.set 'lastUpdated', new Date()
        file_id = audition.get('file')
      auditions.addObject(audition)
    @content.needs[need].set('auditions', auditions)
    if file_id
      @content.get('files').forEach (f) ->
        file = App.File.create().setProperties(f)
        if file.id is file_id
          file.set('status', status)
        files.addObject(file)  
      @content.set 'files', files
    if status is 'accepted'
      @content.needs[need].set('status', 'closed')
    @update()
  closeMix: ->
    @content.set 'status', 'closed'
    @content.mix.set('status', 'closed')
    @update()
  reopenMix: ->
    @content.set 'status', 'tracksComplete'
    @content.mix.set('status', 'open')
    @update()
  closeNeed: (p) ->
    need = parseInt(p.id) - 1
    @content.needs[need].set('status', 'closed')
    @update()
  reopenNeed: (p) ->
    need = parseInt(p.id) - 1
    @content.needs[need].set('status', 'open')
    @update()
  pauseRoughMix: ->
    audio = $('.accepted-audio')[0].controller
    if audio
      @currentTime = audio.currentTime
      audio.pause() 
      $(".rough-mix-play-button").show()
      $(".rough-mix-pause-button").hide()     
  playRoughMix: ->
    audio = $('.accepted-audio')[0].controller
    if audio
      console.log audio.currentTime
      audio.currentTime = @currentTime or 0 if audio.currentTime != 0
      audio.play()
      $(".rough-mix-play-button").hide()
      $(".rough-mix-pause-button").show()
      @currentTime = 0
    else
      alert "There was an error trying to play the rough tracks. This only works in Chrome last I checked."
  playSolo: (id) ->
    audio = $('#'+id)[0]
    if audio then audio.play()
  stopSolo: (id) ->
    audio = $('#'+id)[0]
    if audio then audio.pause()
  toggleMix: (id) ->
    @stopSolo(id)
    if $("#"+id).attr("mediagroup") is "accepted"
      $("#"+id).siblings(".toggle-mix-button").removeClass('selected')
      $("#"+id).siblings(".solo-play-button").removeClass('selected')
      $("#"+id).attr("mediagroup", new Date().getTime())
      @content.get('files').forEach (f) -> if id is f.id then f.set 'tempInMix', false
    else
      $("#"+id).siblings(".toggle-mix-button").addClass('selected')
      $("#"+id).siblings(".solo-play-button").addClass('selected')
      $("#"+id).attr("mediagroup", "accepted")
      @content.get('files').forEach (f) -> if id is f.id then f.set 'tempInMix', true
