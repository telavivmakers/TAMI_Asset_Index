

require './globals.coffee'


c = console.log.bind console
_ = require 'lodash'
express = require 'express'
cookie_parser = require 'cookie-parser'
color = require 'bash-color'
path = require 'path'
fs = require 'fs'
http = require 'http'
Primus = require 'primus'


web_client_arq = do ->
    cookie_parser_secret = 'astenhu093gp.0eeu9ce'
    cookies = cookie_parser cookie_parser_secret
    cookie_parser_secret: cookie_parser_secret
    cookies: cookies
    public_dir: path.resolve('..', 'web_client', 'public')
    index_path: '/index-dev.html'
    port: 3786
    primus_opts:
        transformer: 'websockets'


express_session = require 'express-session'
connect_redis = require 'connect-redis'
Redis_Store = connect_redis express_session

web_client_redis_store_opts = {}
web_client_redis_store = new Redis_Store(web_client_redis_store_opts)


primus_session = (options) ->
    key = options.key or 'connect.sid'
    store = options.store
    primus = @
    if not(store)
        message = 'Session middleware configuration failed due to missing store option.'
        throw new Error(message)
    (req, res, next) ->
        sid = req.signedCookies[key]
        req.session = {}
        if not(sid) then return next()
        store.get sid, (err, session) ->
            if err
                primus.emit 'log', 'error', err
                return next()
            if session then req.session = session
            next()


web_client = express()


web_client.all '/', (req, res, next) ->
    c color.purple(req.url, on)
    res.sendFile path.join(web_client_arq.public_dir, web_client_arq.index_path)


web_client.use express.static(web_client_arq.public_dir)


web_client_server = http.createServer web_client


opts_web_client_primus =
    transformer: 'websockets'


web_client_primus = new Primus(web_client_server, web_client_arq.primus_opts)

web_client_primus.use 'cookies', web_client_arq.cookies
web_client_primus.use 'session', primus_session, { store: web_client_redis_store }
web_client_primus.save path.join(web_client_arq.public_dir, '/js' , '/primus.js')


# the_api = require('./web_client_layer_control/index').default


web_client_server.listen web_client_arq.port, ->
    c 'server on', web_client_arq.port


index_api = require('./index_api.coffee').default

web_client_primus.on 'connection', (spark) ->
    # dispatch to concord if want state
    spark.on 'data', (data) ->

        c data, 'data'

        index_api
            type: data.type
            payload: data.payload
            spark: spark

        # the_api
        #     type: data.type
        #     payload: data.payload
        #     spark: spark

            # spark.write
            #     type: 'lookup_resp'
            #     payload: the_api
            #         # prefix: data.payload.prefix_text
            #         opts:
            #             lookup_type: 'lookup_prefix_000'
