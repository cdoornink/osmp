App.SignupController = Ember.ObjectController.extend
  content: {}
  firstName: null
  lastName: null
  email: null
  password: null
  agreeToTerms: false
  emailIsValid: false
  hasNotAgreed: Ember.computed.not('agreeToTerms')
  
  validateEmail: (->    
    that = this
    App.api "check_availability", "POST", {email:@email}, (response) ->      
      avail = response.available
      re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      valid = re.test(that.email)
      if avail is false then $('.email-signup-group').addClass('warning') else $('.email-signup-group').removeClass('warning')
      if avail is true and valid is true then email = true else email = false
      that.set 'emailIsValid', email
  ).observes('email')
  
  trySignup: ->
    pass = md5(@password)
    data = 
        osmpid: new Date().getTime()
        first_name: @firstName
        last_name: @lastName
        email: @email 
        password: pass
        member_since: new Date()
    that = this
    
    App.api "check_availability", "POST", {email:@email}, (response) ->      
      avail = response.available
      re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      valid = re.test(that.email)
      dontSend = false
      $('.control-group').removeClass('error')
      if data.first_name is null or data.first_name.length is 0
        $('.first-name-signup-group').addClass('error')
        dontSend = true
      if data.last_name is null or data.last_name.length is 0
        $('.last-name-signup-group').addClass('error')
        dontSend = true
      if data.email is null or data.email.length is 0 or valid is false or avail is false
        $('.email-signup-group').addClass('error')
        dontSend = true
      if data.password is null or data.password.length < 3
        $('.password-signup-group').addClass('error')
        dontSend = true
      unless dontSend
        App.api "users", "POST", data, (response) ->
          if response
            user = App.User.create()
            user.setUserProperties response
            App.me.set 'content', user
            App.me.set 'username', user.email
            App.me.set 'password', user.password
            App.me.set 'id', user.id
            localStorage.setItem 'username', user.email
            localStorage.setItem 'password', user.password
            App.me.set 'isError', false
            that.transitionToRoute 'projects'