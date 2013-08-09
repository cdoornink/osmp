App.Project = Ember.Object.extend
  isMine: (->
    return true if @creator and @creator.id is App.me.id
  ).property('creator.id')
  isSetupMode: (->
    return true if @status is "Setup"
  ).property('status')
  tracksLocked: (->
    return true if @status is "TracksComplete" or @status is "closed"
  ).property('status')
  readyToMix: (->
    return true if @status is "TracksComplete"
  ).property('status')
  mixFinal: (->
    return true if @status is "closed"
  ).property('status')
  isClosed: (->
    return true if @status is "closed"
  ).property('status')
  doesNeedMixing: (->
    return true if @status is "true"
  ).property('needsMixing')
  setProjectProperties: (p) ->
    needs = []
    if p.needs then p.needs.forEach (n) -> needs.addObject App.Need.create().setNeedProperties(n)
    files = []
    if p.files then p.files.forEach (f) -> files.addObject App.File.create().setProperties(f)
    mix = null
    if p.mix then mix = App.Mix.create().setProperties(p.mix)
    @set 'needs', needs
    @set 'id', p.osmpid
    @set 'name', p.name
    @set 'description', p.description
    @set 'genre', p.genre
    @set 'creator', p.creator
    @set 'files', files
    @set 'credits', p.credits
    @set 'createdDate', p.created_date
    @set 'lastUpdated', p.last_updated
    @set 'needsMixing', p.needsMixing
    @set 'mix', mix
    @set 'needsMastering', p.needsMastering
    @set 'status', p.status
    
App.Project.reopenClass
  find: (id) ->
    project = App.Project.create()
    App.api "projects/"+id, "GET", {}, (response) ->
      project.setProjectProperties response.project[0]
    project
  
  findAll: ->
    projects = []
    App.api "projects", "GET", {}, (response) ->
      response.projects.forEach (s) ->
        projects.addObject App.Project.create().setProjectProperties(s)
    projects
  
  findRecent: ->
    projects = []
    App.api "projects/recent/all", "GET", {}, (response) ->
      response.projects.forEach (s) ->
        projects.addObject App.Project.create().setProjectProperties(s)
    projects
    
  findAllForUser: (id) ->
    projects = []
    App.api "projects/user/"+id, "GET", {}, (response) ->
      response.projects.forEach (s) ->
        projects.addObject App.Project.create().setProjectProperties(s)
    projects
  
  findAllListed: (ids) ->
    projects = []
    App.api "projects/multiple", "POST", {ids}, (response) ->
      response.projects.forEach (s) ->
        projects.addObject App.Project.create().setProjectProperties(s)
    projects  
    
  new: (data) -> App.api "projects", "POST", data
  
  update: (id, data) -> App.api "projects/"+id, "PUT", data
    
  toJSON: (data) ->
    needs = []
    if data.needs then data.needs.forEach (n) -> needs.addObject App.Need.toJSON(n)
    files = []
    if data.files then data.files.forEach (f) -> files.addObject App.File.toJSON(f)
    mix = null
    if data.mix then mix = App.Mix.toJSON(data.mix)
    project = 
      osmpid: data.id
      user: data.user
      name: data.name
      description: data.description
      genre: data.genre
      creator: data.creator 
      files: files
      needs: needs
      credits: data.credits
      created_date: data.createdDate
      last_updated: data.lastUpdated
      needsMixing: data.needsMixing
      mix: mix
      needsMastering: data.needsMastering
      status: data.status