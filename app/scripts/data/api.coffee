App.api = (req, type, data, callback) ->
  # url = "http://localhost:5000/osmp/"
  url = "http://nameless-beyond-8616.herokuapp.com/osmp/"
  console.log "make "+type+" request for "+req
  $.ajax
    url: url+req
    dataType: 'json'
    type: type
    data: data
    success: (response, status, somethingelse) -> 
      callback(response) if response and callback