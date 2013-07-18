Ember.TextSupport.reopen
  classNames: ["span6"]
 
App.ProjectListView = Ember.View.extend
  classNames: ['project-list']
        
App.ProjectListItemView = Ember.View.extend
  templateName: 'project-list-item'
  classNames: ['project-list-item-container', 'row']
  didInsertElement: ->
    $('.role-icon').tooltip()

App.OwnerUploadView = Ember.View.extend
  classNames: ["owner-upload-container"]
  didInsertElement: ->
    that = this
    $('#owner-fileupload').fileupload
      dataType: 'json'
      progressall: (e, data) ->
        progress = (data.loaded / data.total) * 100
        $('#owner-progress .bar').css 'width', progress + '%'
      done: (e, data) ->
        $('#owner-progress .bar').css 'width', '0%'
        $.each data.result.files, (index, file) ->
          console.log file
          that.get('controller').addOwnerFile(file)
  

App.TrackView = Ember.View.extend
  classNames: ["track"]
  templateName: "track"
  didInsertElement: ->
    $('.icon-box-add').tooltip()
 
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