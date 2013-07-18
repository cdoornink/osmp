Ember.Handlebars.registerBoundHelper "fromNow", (date) ->
  unless date is undefined then return moment(date).fromNow()
  
Ember.Handlebars.registerBoundHelper "mdy", (date) ->
  unless date is undefined then return moment(date).format('MMMM Do YYYY')

Ember.Handlebars.registerBoundHelper "needsIcon", (n) ->
  icon = if n.role is "Mixing/Mastering" then 'mixing' else n.role
  if icon then return new Handlebars.SafeString('<div class="role-icon icon-'+icon.toLowerCase()+' '+n.status.toLowerCase()+'" title="'+n.role.toLowerCase()+' ('+n.status.toLowerCase()+')"></div>')

Ember.Handlebars.registerBoundHelper "acceptedAudio", (url) ->
  if url then return new Handlebars.SafeString('<audio class="accepted-audio" mediagroup="accepted"><source src="'+url+'"><source src="http://magnifywebdesign.com/osmp/server/php/files/Audio%2003_04.wav"></audio>')

Ember.Handlebars.registerBoundHelper "downloadAudio", (file) ->
  if file then return new Handlebars.SafeString('<a class="icon-box-add" href="'+file.url+'" download="'+file.name+'" title="download '+file.name+'"></a>')
  
Ember.Handlebars.registerBoundHelper "auditionText", (a) ->
  if a.status == "open"
    return new Handlebars.SafeString('<div class="audition">'+a.name+' signed up to audition '+moment(a.lastUpdated).fromNow()+'</div>')
  if a.status == "submitted"
    return new Handlebars.SafeString('<div class="audition">'+a.name+' submitted their track '+moment(a.lastUpdated).fromNow()+'</div>')
  if a.status == "accepted"
    return new Handlebars.SafeString('<div class="audition">'+a.name+"'s track was accepted "+moment(a.lastUpdated).fromNow()+'</div>')
  if a.status == "rejected"
    return new Handlebars.SafeString('<div class="audition">'+a.name+"'s track was rejected "+moment(a.lastUpdated).fromNow()+'</div>')

Ember.Handlebars.registerBoundHelper "showMyRole", (need) ->
  if need.auditions
    for a in need.auditions
      if a.id == App.me.id
        # this wont work. You need to create a boolean helper and do if statements in the template
        return new Handlebars.SafeString('You are currently auditioning for this part. <button class="btn" {{action submitTrack need}}>Submit Track</button>')
  return new Handlebars.SafeString('This part is '+need.status+' <button class="btn" {{action audition need}}>Audition</button>')

Ember.TextField.reopen
  attributeBindings: ["required"]