





input_data = rc require('../components/input_data_000.coffee').default






comp = rr
    getInitialState: ->
        search_or_input: 'input'

    render: ->
        # div null, (p null, 'hello')
        div
            style:
                display: 'flex'
                flexDirection: 'column'
                alignItems: 'center'
                backgroundColor: 'lightgrey'
            h1
                style:
                    textAlign: 'center'
                "Tami Index"
            div
                style:
                    display: 'flex'
                    justifyContent: 'space-around'
                button
                    style:
                        opacity: if @state.search_or_input is 'search' then .3 else 1
                        cursor: 'pointer'
                    onClick: => @setState { search_or_input: 'search' }
                    "search data"
                button
                    style:
                        opacity: if @state.search_or_input is 'input' then .3 else 1
                        cursor: 'pointer'
                    onClick: => @setState { search_or_input: 'input' }
                    "input data"

            if @state.search_or_input is 'input'
                input_data()
            else
                h4 null, 'search data placeholder'


map_state_to_props = (state) ->
    state.get('tami_index').toJS()


map_dispatch_to_props = (dispatch) ->
    {}



exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
