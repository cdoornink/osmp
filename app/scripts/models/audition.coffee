App.Audition = Ember.Object.extend
  addToMix: false
  setProperties: (a) ->
    @set 'id', a.id
    @set 'name', a.name
    @set 'lastUpdated', a.lastUpdated
    @set 'status', a.status
    @set 'file', a.file
  isAccepted: (->
    return true if @status is "accepted"
  ).property('status')
  isMine: (->
    return true if @name is App.me.name
  ).property('name')

App.Audition.reopenClass  
  toJSON: (a) ->
    id: a.id
    name: a.name
    lastUpdated: a.lastUpdated
    status: a.status
    file: a.file
