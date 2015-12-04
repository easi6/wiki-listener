express = require 'express'
util = require 'util'
co = require 'co'
Promise = require 'bluebird'
bodyparser = require 'body-parser'
config = require 'config'
https = require 'https'
querystring = require 'querystring'
URL = require 'url'

https_post = (url, params) ->
  postData = JSON.stringify(params)
  url = URL.parse(url)
  new Promise (rs, rj) ->
    response = ""
    options =
      hostname: url.hostname
      path: url.path
      method: "POST"
      headers:
        "Content-Type": "application/json"
    req = https.request options, (res) ->
      res.setEncoding("utf8")
      res.on "data", (d) ->
        response += d
      res.on "end", ->
        rs response

    req.on "error", (e) -> rj e
    req.write postData
    req.end()

app = express()

app.use bodyparser.urlencoded(extended: true)
app.use bodyparser.json()

app.post "/github_notification", (req, res) ->
  co ->
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

      response = yield https_post config.slack_webhook, parameters

    res.send 200
  .catch (err) ->
    res.status(500).send(err.message)

port = process.env.PORT || 9000
server = app.listen parseInt(port), ->
  console.log "app listening.."
