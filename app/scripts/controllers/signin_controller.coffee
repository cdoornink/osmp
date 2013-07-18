App.SigninController = Ember.ObjectController.extend
  isError: false
  username: null
  password: null
  name: null
  id: null
  content: 
    reviews: []
    songs: []
  canUpload: false
  reviewsLeftBeforeUpload: 0
  
  tryLogin: (auto) ->
    that = this
    App.api "auth", "POST", {email:@username,password:@password}, (response) ->
      if response.user
        user = App.User.create()
        user.setUserProperties response.user
        App.me.set 'content', user
        App.me.set 'username', user.email
        App.me.set 'password', user.password
        App.me.set 'name', (App.me.content.get('firstName') + " " + App.me.content.get('lastName'))
        App.me.set 'id', user.id
        localStorage.setItem 'username', user.email
        localStorage.setItem 'password', user.password
        App.me.set 'isError', false
        unless auto then that.transitionToRoute 'projects'
      else unless auto
        App.me.set 'isError', true
        App.me.set 'password', null

App.me = App.SigninController.create()