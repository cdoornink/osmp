module "Integration Tests",
  setup: ->
    App.reset()

test "Header", ->
  visit("/").then ->
    ok find(".brand:contains('Open Source Music Project')").length, "Header title is present"
    ok find(".nav li a:contains('Browse')").length, "Browse link in the header"
    
test "Home Page", ->
  visit("/").then ->
    ok find("h1:contains('Open Source Music Project')").length, "Title is present"
    ok find(".btn:contains('Sign Up')").length, "Sign up button is present"

test "Sign Up", ->
  visit("/")
  .click(".jumbotron .btn.btn-primary").then ->
    ok find(".signup-page h2:contains('Sign Up')").length, "Sign up button goes to sign up page"
  
# test "show browse projects page", ->
#   visit("/projects").then ->
#     equal find(".project-list-item-container").length, 2, "The first page should have 2 projects"
#     notEqual find(".project-list-item-container").length, 0, "The first page should have at least 1 project"
# 
