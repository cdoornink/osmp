App.Need = Ember.Object.extend
  auditions: []
  
  setNeedProperties: (n) ->
    auditions = []
    if n.auditions then n.auditions.forEach (a) -> auditions.addObject App.Audition.create().setProperties(a)
    @set 'id', n.id
    @set 'role', n.role
    @set 'details', n.details
    @set 'status', n.status
    @set 'auditions', auditions
  
  isOpen: (->
    return true if @status is 'open'
  ).property('status')
  isMine: (->
    for audition in @auditions
      return true if audition.id is App.me.id
  ).property('auditions.@each.status')
  isSubmitted: (->
    for audition in @auditions
      return true if audition.id is App.me.id and audition.status is "submitted"
  ).property('auditions.@each.status')
  isAccepted: (->
    for audition in @auditions
      return true if audition.id is App.me.id and audition.status is "accepted"
  ).property('auditions.@each.status')
  isRejected: (->
    for audition in @auditions
      return true if audition.id is App.me.id and audition.status is "rejected"
  ).property('auditions.@each.status')

App.Need.reopenClass  
  toJSON: (n) ->
    auditions = []
    if n.auditions then n.auditions.forEach (a) -> auditions.addObject App.Audition.toJSON(a)
    id: n.id
    role: n.role
    details: n.details
    status: n.status
    auditions: auditions
