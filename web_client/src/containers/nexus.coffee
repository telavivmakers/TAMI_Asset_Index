

home = rc require('../scenes/home.coffee').default

dashboard = rc require('../scenes/dashboard.coffee').default
dashboard_001 = rc require('../scenes/dashboard_001.coffee').default
ufo = rc require('../scenes/ufo.coffee').default



render = ->
    switch @props.hash_location
        when 'dashboard'
            dashboard_001()
        when 'ufo'
            ufo()
        else 'routing error'


comp = rr
    render: render


map_state_to_props = (state) ->
    state.get('tami_index').toJS()


map_dispatch_to_props = (dispatch) ->
    {}

exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
