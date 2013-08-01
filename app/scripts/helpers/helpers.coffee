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
    if a.name is App.me.name
      message = "You signed up to audition"
    else
      message = a.name+' signed up to audition'
  if a.status == "submitted"
    if a.name is App.me.name
      message = 'You submitted your track'
    else
      message = a.name+' submitted their track'
  if a.status == "accepted"
    if a.name is App.me.name
      message = "Your track was <span class='accepted-text'>accepted</span>"
    else
      message = a.name+"'s track was <span class='accepted-text'>accepted</span>"
  if a.status == "rejected"
    if a.name is App.me.name
      message = "Your track was <span class='rejected-text'>rejected</span>"
    else
      message = a.name+"'s track was <span class='rejected-text'>rejected</span>"
  if message
    return new Handlebars.SafeString(message+' '+moment(a.lastUpdated).fromNow())

Ember.Handlebars.registerBoundHelper "playAuditionSolo", (a, files) ->
  if a.file
    url = null
    files.forEach (f) -> if a.file is f.id then url = f.url
    if url then return new Handlebars.SafeString('<audio id="'+a.file+'" class="solo-audio"><source src="'+url+'"></audio>')
      
Ember.Handlebars.registerBoundHelper "downloadAuditionAudio", (a, files) ->
  if a.file
    file = null
    files.forEach (f) -> if a.file is f.id then file = f
    if file then return new Handlebars.SafeString('<a class="icon-box-add" href="'+file.url+'" download="'+file.name+'" title="download '+file.name+'"></a>')
      
Ember.TextField.reopen
  attributeBindings: ["required"]