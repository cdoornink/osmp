App.CreateController = Ember.ObjectController.extend
  content: {}
  name: null
  artist: null
  description: null
  bpm: null
  src: null
  genre: null
  agreeToTerms: false
  hasNotAgreed: Ember.computed.not('agreeToTerms')
  needsMixing: false
  needsMastering: false
  need1: null
  need2: null
  need3: null
  need4: null
  need5: null
  need6: null
  need7: null
  need8: null
  need9: null
  need10: null
  details1: null
  details2: null
  details3: null
  details4: null
  details5: null
  details6: null
  details7: null
  details8: null
  details9: null
  details10: null
  project_needs: []
  roles: 1  
  addNeed: ->
    @incrementProperty('roles')
    unless @roles > 10
      $(".need"+@roles).show()
      if @roles is 10
        $(".add-need-button").hide()
  submitProject: ->
    id = new Date().getTime()
    @set 'project_needs', []
    if @need1 isnt 'Select a Role' then @project_needs.addObject {"id": "1", "role": @need1, "details": @details1, "status": "open", "auditions": [{status: "empty"}]}
    if @need2 isnt 'Select a Role' then @project_needs.addObject {"id": "2", "role": @need2, "details": @details2, "status": "open", "auditions": [{status: "empty"}]}
    if @need3 isnt 'Select a Role' then @project_needs.addObject {"id": "3", "role": @need3, "details": @details3, "status": "open", "auditions": [{status: "empty"}]}
    if @need4 isnt 'Select a Role' then @project_needs.addObject {"id": "4", "role": @need4, "details": @details4, "status": "open", "auditions": [{status: "empty"}]}
    if @need5 isnt 'Select a Role' then @project_needs.addObject {"id": "5", "role": @need5, "details": @details5, "status": "open", "auditions": [{status: "empty"}]}
    if @need6 isnt 'Select a Role' then @project_needs.addObject {"id": "6", "role": @need6, "details": @details6, "status": "open", "auditions": [{status: "empty"}]}
    if @need7 isnt 'Select a Role' then @project_needs.addObject {"id": "7", "role": @need7, "details": @details7, "status": "open", "auditions": [{status: "empty"}]}
    if @need8 isnt 'Select a Role' then @project_needs.addObject {"id": "8", "role": @need8, "details": @details8, "status": "open", "auditions": [{status: "empty"}]}
    if @need9 isnt 'Select a Role' then @project_needs.addObject {"id": "9", "role": @need9, "details": @details9, "status": "open", "auditions": [{status: "empty"}]}
    if @need10 isnt 'Select a Role' then @project_needs.addObject {"id": "10", "role": @need10, "details": @details10, "status": "open", "auditions": [{status: "empty"}]}
    project = 
      osmpid: id
      name: @name
      description: @description
      bpm: @bpm
      genre: @genre 
      creator: {"id": App.me.get('id'), "name": App.me.name}
      needs: @project_needs
      needsMixing: @needsMixing
      needsMastering: @needsMastering
      created_date: new Date()
      last_updated: new Date()
      status: "setup"
    App.Project.new {project: project}
    if App.me.content.get('projects')
      App.me.content.projects.push(id)
    else
      App.me.content.set('projects', [id])
    App.User.update()
    @transitionToRoute 'project', App.Project.create().setProjectProperties(project)
    

