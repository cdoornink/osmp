App.Mix = Ember.Object.extend
  auditions: []
  
  setProperties: (m) ->
    auditions = []
    if m.auditions then m.auditions.forEach (a) -> auditions.addObject App.Audition.create().setProperties(a)
    @set 'details', m.details
    @set 'status', m.status
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
      return true if audition.id is App.me.id and audition.status is "submittedMix"
  ).property('auditions.@each.status')
  isAccepted: (->
    for audition in @auditions
      return true if audition.id is App.me.id and audition.status is "acceptedMix"
  ).property('auditions.@each.status')
  isRejected: (->
    for audition in @auditions
      return true if audition.id is App.me.id and audition.status is "rejectedMix"
  ).property('auditions.@each.status')

App.Mix.reopenClass  
  toJSON: (m) ->
    auditions = []
    if m.auditions then m.auditions.forEach (a) -> auditions.addObject App.Audition.toJSON(a)
    details: m.details
    status: m.status
    auditions: auditions
