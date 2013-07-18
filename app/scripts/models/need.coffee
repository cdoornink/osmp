App.Need = Ember.Object.extend
  auditions: []
  
  setNeedProperties: (n) ->
    @set 'id', n.id
    @set 'role', n.role
    @set 'details', n.details
    @set 'status', n.status
    @set 'auditions', n.auditions
  
  isMine: (->
    for audition in @auditions
      return true if audition.id is App.me.id
  ).property('auditions.@each.status')

App.Need.reopenClass  
  toJSON: (n) ->
    id: n.id
    role: n.role
    details: n.details
    status: n.status
    auditions: n.auditions
