App.File = Ember.Object.extend
  setProperties: (f) ->
    @set 'id', f.id
    @set 'name', f.name
    @set 'type', f.type
    @set 'url', f.url
    @set 'size', f.size
    @set 'deleteType', f.delete_type
    @set 'deleteUrl', f.delete_url
    @set 'user', f.user
    @set 'status', f.status
    @set 'date', f.date
    @set 'role', f.role
    @set 'need', f.need
  isAccepted: (->
    return true if @status is "accepted"
  ).property('status')
  isAcceptedMix: (->
    return true if @status is "acceptedMix"
  ).property('status')
  isMine: (->
    console.log @user
    return true if @user.name is App.me.name
  ).property('user')
    
App.File.reopenClass  
  toJSON: (f) ->
    id: f.id
    name: f.name
    type: f.type
    url: f.url
    size: f.size
    delete_type: f.deleteType
    delete_url: f.deleteUrl
    user: f.user
    status: f.status
    date: f.date
    role: f.role
    need: f.need
