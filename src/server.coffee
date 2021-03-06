path = require 'path'
http = require 'http'
derby = require 'derby'
express = require 'express'
orca = module.exports = require './orca'

orca.root = path.dirname __dirname
orca.assets = path.join orca.root, 'public'

orca.Bot = require './bot'
orca.createBot = (opts) ->
  new orca.Bot opts

expressApp = express.createServer()
  .use(express.favicon())
  .use(express.static orca.assets)
  .use(orca.router())

orca.server = http.createServer expressApp

derby.use(require 'racer-db-mongo')

orca.store = orca.createStore
  listen: orca.server
  db:
    type: 'Mongo'
    uri: 'mongodb://localhost/orca'

orca.bot = orca.createBot
  store: orca.store
  nick: 'orca'
  channels: ['#derbyjs', '#pwn']
  debug: true

if require.main is module
  orca.server.listen 3000
