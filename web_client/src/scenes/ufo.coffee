


neonBlue = 'rgb(0, 229, 255)'
blueyGrey = 'rgb(155, 170, 183)'
marine62 = 'rgb(6, 44, 75)'




email_entry = ->
    form
        onSubmit: (e) =>
            e.preventDefault()
            @setState
                phase: 'password_entry'
        input
            style:
                backgroundColor: neonBlue
                height: .04 * wh
                fontSize: .024 * wh
                textAlign: 'center'
                fontStyle: 'italic'
                borderRadius: .008 * wh
                color: 'white'
            type: 'email'
            placeholder: 'EMAIL'
            value: @state.email
            onChange: (e) =>
                email_candide = e.currentTarget.value
                @setState
                    email: email_candide
                @props.check_email_avail { email_candide }


password_entry = ->
    form
        style:
            display: 'flex'
            flexDirection: 'column'
        onSubmit: (e) =>
            e.preventDefault()
        input
            style:
                backgroundColor: neonBlue
                height: .04 * wh
                fontSize: .024 * wh
                textAlign: 'center'
                fontStyle: 'italic'
                borderRadius: .008 * wh
                color: 'white'
            value: @state.password
            onChange: (e) =>
                @setState
                    password: e.currentTarget.value
            type: 'password'
            placeholder: 'PASSWORD'
        input
            style:
                backgroundColor: neonBlue
                height: .04 * wh
                fontSize: .024 * wh
                textAlign: 'center'
                fontStyle: 'italic'
                borderRadius: .008 * wh
                color: 'white'
            value: @state.password_confirm
            onChange: (e) =>
                @setState
                    password_confirm: e.currentTarget.value
            type: 'password'
            placeholder: 'CONFIRM PASSWORD'


render = ->
    div
        style:
            display: 'flex'
            flexDirection: 'column'
            # justifyContent: 'space-around'
            alignItems: 'center'
            backgroundColor: marine62
            height: wh
        p
            style:
                fontSize: .012 * wh
                color: 'white'
            'TAMI-Index'
        p
            style:
                fontSize: .019 * wh
                color: 'white'
                fontStyle: 'italic'
            'SIGNUP'
        switch @state.phase
            when 'email_entry'
                email_entry.bind(@)()
            when 'password_entry'
                password_entry.bind(@)()


# TODO : websocketts checks for email name availability





comp = rr

    getInitialState: ->
        phase: 'email_entry'
        password: ''
        password_confirm: ''
        email: ''

    render: render


map_state_to_props = (state) ->
    state.get('tami_index').toJS()


map_dispatch_to_props = (dispatch) ->
    check_email_avail: ({ email_candide }) ->
        dispatch
            type: 'check_email_avail'
            payload: { email_candide }



exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
