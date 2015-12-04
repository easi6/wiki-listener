express = require 'express'
util = require 'util'
co = require 'co'
Promise = require 'bluebird'
bodyparser = require 'body-parser'

app = express()

app.use bodyparser.urlencoded(extended: true)
app.use bodyparser.json()

app.post "/github_notification", (req, res) ->
  change_pages = req.body.pages
  author = req.body.sender

  change_pages.forEach (change_page) ->
    message = "<#{change_page.html_url}|#{change_page.title}> #{change_page.action}"
    username = author.login
    usericon = author.avatar_url

    parameters = 
      text: message
      username: username
      icon_url: usericon

  res.send 200

port = process.env.PORT || 9000
server = app.listen parseInt(port), ->
  console.log "app listening.."
