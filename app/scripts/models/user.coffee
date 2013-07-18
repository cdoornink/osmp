App.User = Ember.Object.extend
  setUserProperties: (properties) ->
    @set("id", properties.osmpid);   
    @set("firstName", properties.first_name)
    @set("lastName", properties.last_name)
    @set("email", properties.email)
    @set("password", properties.password)
    @set("memberSince", properties.member_since)
    @set("projects", properties.projects)
    @set("participating", properties.participating)
    
App.User.reopenClass
  find: (id) ->
    user = App.User.create()
    App.api "users/"+id, "GET", {}, (response) ->
      user.setUserProperties(response.user)
    user
     
  update: -> App.api "users/"+App.me.content.id, "PUT", App.User.toJSON()
    
  toJSON:  ->
    user = 
      osmpid: App.me.content.id
      first_name: App.me.content.firstName
      last_name: App.me.content.lastName
      email: App.me.content.email
      password: App.me.content.password
      member_since: App.me.content.memberSince
      projects: App.me.content.projects
      participating: App.me.content.participating