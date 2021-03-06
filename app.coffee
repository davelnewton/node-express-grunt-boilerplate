express = require 'express'
routes = require './routes/routes'
http = require 'http'
path = require 'path'
injector = require 'render-options-injector'
config = require('./config').config

unless config.port
  console.error "config.port is missing. Check out \"config.coffee\" file."
  process.exit 1

app = express()

app.set 'port', config.port
app.set 'views', __dirname + '/views'
app.set 'view engine', 'jade'
app.use express.favicon()
app.use express.logger 'dev'
app.use express.urlencoded()
app.use express.json()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join __dirname, 'public')

app.configure 'development', ->
  app.use express.errorHandler({dumpExceptions: true, showStack: true})

app.configure 'production', ->
  app.use express.errorHandler()

app.get '/', routes.index
app.get '/login', routes.login

injector.inject app, {env: app.settings.env}

http.createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port #{app.get('port')} in #{app.settings.env} mode"
