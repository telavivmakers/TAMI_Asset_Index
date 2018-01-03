




# TODO factor this out to a common constants shared resource file
PREPARE = 'prepare'
IN_PROGRESS = 'in_progress'
COMPLETED = 'completed'
SUBMIT_DATA_JOB_STATUS = 'SUBMIT_DATA_JOB_STATUS'



comp = rr

    form_not_ready: -> (@state.stuff is '') or (@state.owner_name is '') or (@state.slot_name is '')

    getInitialState: ->

        form_status: PREPARE

        slot_name: ''
        owner_name: ''
        stuff: ''

    render: ->
        div
            style:
                display: 'flex'
                flexDirection: 'column'
                alignItems: 'center'
            h3
                style:
                    textAlign: 'center'
                'input data'
            input
                disabled: @state.form_status is IN_PROGRESS
                style:
                    textAlign: 'center'
                    margin: "#{.02 * wh}px #{.02 * wh}px #{.02 * wh}px #{.02 * wh}px"
                placeholder: 'space slot_name'
                onChange: (e) =>
                    # c 'space slot_name', e.currentTarget.value
                    val = e.currentTarget.value
                    @setState
                        slot_name: val
                    @props.lookahead
                        field_type: 'slot_name'
                        field_str: val
            input
                disabled: @state.form_status is IN_PROGRESS
                style:
                    textAlign: 'center'
                    margin: "#{.02 * wh}px #{.02 * wh}px #{.02 * wh}px #{.02 * wh}px"
                placeholder: 'the owner_name'
                onChange: (e) =>
                    val = e.currentTarget.value
                    @setState
                        owner_name: val
                    @props.lookahead
                        field_type: 'owner_name'
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
                    if (@state.stuff isnt '') and (@state.slot_name isnt '') and (@state.owner_name isnt '')
                        @props.submit_data_form
                            slot_name: @state.slot_name
                            owner_name: @state.owner_name
                            stuff: @state.stuff
                        @setState
                            form_status: IN_PROGRESS
                "submit data form"


            c @props.SUBMIT_DATA_JOB_STATUS, 'job status'
            if @props.SUBMIT_DATA_JOB_STATUS isnt PREPARE
                svg
                    # x: 800
                    # y: 400
                    width: 50
                    height: 70
                    rect
                        x: 0
                        y: 20
                        width: 50
                        height: 50
                        fill: if @props.SUBMIT_DATA_JOB_STATUS is IN_PROGRESS then 'grey' else 'green'
                        fillOpacity: .3
                    text
                        x: 0
                        y: 40
                        fontSize: .02 * wh
                        fontFamily: 'sans'
                        fill: if @props.SUBMIT_DATA_JOB_STATUS is IN_PROGRESS then 'yellow' else 'chartreuse'
                        if @props.SUBMIT_DATA_JOB_STATUS is IN_PROGRESS
                            '...upload in progress'
                        else
                            '...upload completed'



map_state_to_props = (state) ->
    state.get('tami_index').toJS()

map_dispatch_to_props = (dispatch) ->

    lookahead: ({ field_type, field_str }) ->
        dispatch
            type: 'primus_hotwire'
            payload:
                type: 'lookahead'
                payload: { field_type, field_str }



    submit_data_form: ({ slot_name, owner_name, stuff }) ->
        dispatch
            # type: 'primus_hotwire'
            # payload:
            type: 'submit_data_form'
            payload: { slot_name, owner_name, stuff }
            "submit_data_form"

exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
