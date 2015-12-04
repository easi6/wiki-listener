express = require 'express'
util = require 'util'
co = require 'co'
Promise = require 'bluebird'

app = express()

app.get "/github_notification", (req, res) ->
  console.dir req.body

port = process.env.PORT || 9000
server = app.listen parseInt(port), ->
  console.log "app listening.."
