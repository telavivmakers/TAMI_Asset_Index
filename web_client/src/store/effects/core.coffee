

api = {}












api.submit_data_form = ({ effect, state, store  }) ->
    # c arguments
    { type, payload } = effect
    primus.write { type, payload }

















api.signup = ({ effect, state, store }) ->
    primus.write
        type: 'signup'
        payload: effect.payload



api.check_email_avail = ({ effect, state, store }) ->
    primus.write
        type: 'check_email_avail'
        payload: effect.payload



api['primus_hotwire'] = ({ effect, state }) ->
    { type, payload } = effect.payload
    # c 'writing'
    primus.write { type, payload }



# arq['build_selection'] = ({ desire, state }) ->
#     primus.write
#         type: 'build_selection'
#         payload: desire.payload


api['init_primus'] = ({ effect, store, state }) ->
    c 'initialising primus'
    primus.on 'data', (data) ->
        c 'primus received data', data
        store.dispatch
            type: 'primus:data'
            payload: { data, store }

    setInterval =>
        primus.write
            type: 'request_orient'
            payload: 43
    , 3000



api.setup_listen_location = ({ effect, state, store }) ->
    window.location.hash = 'ufo'
    window.addEventListener 'hashchange', ->
        location = window.location.hash.replace(/^#\/?|\/$/g, '').split('/')[0]
        store.dispatch
            type: 'hash_location_change'
            payload: { location }
    , false


exports.default = api
