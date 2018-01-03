





PREPARE = 'prepare'
IN_PROGRESS = 'in_progress'
# COMPLETED = 'completed'



comp = rr

    form_not_ready: -> (@state.stuff is '') or (@state.owner is '') or (@state.slot is '')

    getInitialState: ->

        form_status: PREPARE

        slot: ''
        owner: ''
        stuff: ''

    render: ->
        div
            style:
                display: 'flex'
                flexDirection: 'column'
            h3
                style:
                    textAlign: 'center'
                'input data'
            input
                disabled: @state.form_status is IN_PROGRESS
                style:
                    textAlign: 'center'
                    margin: "#{.02 * wh}px #{.02 * wh}px #{.02 * wh}px #{.02 * wh}px"
                placeholder: 'space slot'
                onChange: (e) =>
                    # c 'space slot', e.currentTarget.value
                    val = e.currentTarget.value
                    @setState
                        slot: val
                    @props.lookahead
                        field_type: 'slot'
                        field_str: val
            input
                disabled: @state.form_status is IN_PROGRESS
                style:
                    textAlign: 'center'
                    margin: "#{.02 * wh}px #{.02 * wh}px #{.02 * wh}px #{.02 * wh}px"
                placeholder: 'the owner'
                onChange: (e) =>
                    val = e.currentTarget.value
                    @setState
                        owner: val
                    @props.lookahead
                        field_type: 'owner'
                        field_str: val
            textArea
                disabled: @state.form_status is IN_PROGRESS
                style:
                    margin: "#{.02 * wh}px #{.02 * wh}px #{.02 * wh}px #{.02 * wh}px"
                    textAlign: 'center'
                    height: .2 * wh
                    width: .3 * ww
                placeholder: 'the stuff'
                onChange: (e) =>
                    val = e.currentTarget.value
                    @setState
                        stuff: val
                    @props.lookahead
                        field_type: 'stuff'
                        field_str: val

            button
                style:
                    cursor: 'pointer'
                    height: .05 * wh
                disabled: @form_not_ready() or (@state.form_status is IN_PROGRESS)
                onClick: =>
                    if (@state.stuff isnt '') and (@state.slot isnt '') and (@state.owner isnt '')
                        @props.submit_data_form
                            slot: @state.slot
                            owner: @state.owner
                            stuff: @state.stuff
                        @setState
                            form_status: IN_PROGRESS
                "submit data form"


map_state_to_props = (state) ->
    state.get('tami_index').toJS()

map_dispatch_to_props = (dispatch) ->

    lookahead: ({ field_type, field_str }) ->
        dispatch
            type: 'primus_hotwire'
            payload:
                type: 'lookahead'
                payload: { field_type, field_str }



    submit_data_form: ({ slot, owner, stuff }) ->
        dispatch
            type: 'primus_hotwire'
            payload:
                type: 'submit_data_form'
                payload: { slot, owner, stuff }
            "submit_data_form"

exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
