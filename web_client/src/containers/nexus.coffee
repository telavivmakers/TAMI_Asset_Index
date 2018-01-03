

home = rc require('../scenes/home.coffee').default

dashboard = rc require('../scenes/dashboard.coffee').default
dashboard_001 = rc require('../scenes/dashboard_001.coffee').default

render = ->
    # home()
    dashboard_001()

comp = rr
    render: render

map_state_to_props = (state) ->
    {}

map_dispatch_to_props = (dispatch) ->
    {}

exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
