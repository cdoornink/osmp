Ember.TextSupport.reopen
  classNames: ["span6"]
 
App.ProjectListView = Ember.View.extend
  classNames: ['project-list']
        
App.ProjectListItemView = Ember.View.extend
  templateName: 'project-list-item'
  classNames: ['project-list-item-container', 'row']
  classNameBindings: ['getStatus']
  getStatus: (->
    this.content.get('status')
  ).property('content.status')
  didInsertElement: ->
    $('.role-icon').tooltip()

App.OwnerUploadView = Ember.View.extend
  classNames: ["owner-upload-container"]
  didInsertElement: ->
    that = this
    $('#owner-fileupload').fileupload
      dataType: 'json'
      add: (e, data) ->
        uploadFile = data.files[0];
        if (!(/\.(mp3)$/i).test(uploadFile.name))
          alert "You can only upload mp3 files."
        else
          data.submit()
      progressall: (e, data) ->
        progress = (data.loaded / data.total) * 100
        $('#owner-progress .bar').css 'width', progress + '%'
      done: (e, data) ->
        $('#owner-progress .bar').css 'width', '0%'
        $.each data.result.files, (index, file) ->
          console.log file
          that.get('controller').addOwnerFile(file)

App.AuditionerUploadView = Ember.View.extend
  classNames: ["owner-upload-container"]
  didInsertElement: ->
    that = this
    $('#auditioner-fileupload').fileupload
      dataType: 'json'
      add: (e, data) ->
        uploadFile = data.files[0];
        if (!(/\.(mp3)$/i).test(uploadFile.name))
          alert "You can only upload mp3 files."
        else
          data.submit()
      progressall: (e, data) ->
        progress = (data.loaded / data.total) * 100
        $('#auditioner-progress .bar').css 'width', progress + '%'
      done: (e, data) ->
        $('#auditioner-progress .bar').css 'width', '0%'
        $.each data.result.files, (index, file) ->
          that.get('controller').addAuditionerFile(file, that.get('content'))

App.MixUploadView = Ember.View.extend
  classNames: ["owner-upload-container"]
  didInsertElement: ->
    that = this
    $('#mix-fileupload').fileupload
      dataType: 'json'
      add: (e, data) ->
        uploadFile = data.files[0];
        if (!(/\.(mp3)$/i).test(uploadFile.name))
          alert "You can only upload mp3 files."
        else
          data.submit()
      progressall: (e, data) ->
        progress = (data.loaded / data.total) * 100
        $('#mix-progress .bar').css 'width', progress + '%'
      done: (e, data) ->
        $('#mix-progress .bar').css 'width', '0%'
        $.each data.result.files, (index, file) ->
          that.get('controller').addMixFile(file)
  

App.TrackView = Ember.View.extend
  classNames: ["track"]
  templateName: "track"
  didInsertElement: ->
    $('.icon-box-add').tooltip()
    $(".icon-remove").tooltip()
    
App.AuditionListView = Ember.View.extend
  classNames: ["audition"]
  didInsertElement: ->
    $('.toggle-mix-button').tooltip()
    $('.solo-play-button').tooltip()
    $(".icon-remove").tooltip()
     
#  NEED TO FIGURE OUT HOW THIS WILL ALL WORK WITH MULTIPLE PLAYERS ON A PAGE...
App.ProgressView = Ember.View.extend
  progressChanged: (->
    progress = parseInt(@get('controller.progress')*100, 10)
    $('#rough-mix-progress .bar').css 'width', progress + '%'
  ).observes('controller.progress')
  
App.AcceptedAudioFileView = Ember.View.extend
  didInsertElement: ->
    audio = $('.accepted-audio')[0].controller
    audio.addEventListener("timeupdate", @progressChanged, false)
  progressChanged: (->
    audio = $('.accepted-audio')[0].controller   
    progress = (audio.currentTime / audio.duration)*100
    $('#rough-mix-progress .bar').css 'width', progress + '%'
  ).observes('progress')