@App = Ember.Application.create()

App.Router.map ->
  @resource 'signin'
  @resource 'signup'
  @resource 'signout'
  @resource 'projects'
  @resource 'project', {path:'/projects/:project_id'}
  @resource 'create'
  @resource 'my-projects'
  @resource 'terms'
  
App.ApplicationRoute = Ember.Route.extend
  beforeModel: ->
    App.me.set 'username', localStorage.getItem('username')
    App.me.set 'password', localStorage.getItem('password')
    App.me.tryLogin(true)

App.IndexRoute = Ember.Route.extend
  redirect: -> @transitionTo 'projects' if App.me.get "id"

App.SignupRoute = Ember.Route.extend
  redirect: -> @transitionTo 'projects' if App.me.get "id"

App.SignoutRoute = Ember.Route.extend
  redirect: -> @transitionTo 'projects' if App.me.get "id"

App.SignoutRoute = Ember.Route.extend
  redirect: ->
    localStorage.clear()
    App.me.set 'content', {}
    App.me.set 'password', null
    App.me.set 'username', null
    App.me.set 'id', null
    @transitionTo 'index'

App.ProjectsRoute = Ember.Route.extend
  model: ->  
    App.Project.findRecent()
  setupController: (controller, model) ->
    controller.set "model", model

App.ProjectRoute = Ember.Route.extend
  model: (params) ->  
    App.Project.find params.project_id
  setupController: (controller, model) ->
    controller.set "model", model

App.MyProjectsRoute = Ember.Route.extend
  redirect: ->
    unless App.me.id
      @transitionTo 'projects'
  setupController: (controller, model) ->
    projects_model = []
    id = App.me.id
    if id then projects_model = App.Project.findAllForUser(id)
    controller.set "created", projects_model
    parts_model = []
    ids = App.me.content.participating if App.me.content
    if ids then parts_model = App.Project.findAllListed(ids)
    controller.set "participating", parts_model
    
   

    


