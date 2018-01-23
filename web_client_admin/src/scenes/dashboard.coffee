











comp = rr
    getInitialState: ->
        {}

    render: ->
        # div null, (p null, 'hello')
        div
            style:
                display: 'flex'
                flexDirection: 'column'
                backgroundColor: 'lightgrey'
            h1
                style:
                    textAlign: 'center'
                "Tami Index"
            div
                style:
                    display: 'flex'

                div
                    style:
                        display: 'flex'
                        flexDirection: 'column'
                    h4
                        style: {}
                        "Search"
                    input
                        placeholder: 'search-000'
                    input
                        placeholder: 'search-001'
                div
                    style: {}
                    h5 null, 'search-001'





map_state_to_props = (state) ->
    state.get('tami_index').toJS()


map_dispatch_to_props = (dispatch) ->
    {}



exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
