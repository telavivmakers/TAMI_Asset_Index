


neonBlue = 'rgb(0, 229, 255)'
blueyGrey = 'rgb(155, 170, 183)'
marine62 = 'rgb(6, 44, 75)'




email_entry = ->
    form
        onSubmit: (e) =>
            e.preventDefault()
            if @props.email_avail
                @setState
                    phase: 'password_entry'
            else
                c 'TODO trigger a flashing animation'
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
        unless @props.email_avail is null
            p
                style:
                    fontSize: .016 * wh
                    fontStyle: 'italic'
                    color: if @props.email_avail then 'lightgreen' else 'magenta'
                if @props.email_avail then "ok" else "This email is already associated with an account."

password_entry = ->
    form
        style:
            display: 'flex'
            flexDirection: 'column'
        onSubmit: (e) =>
            c 'pwd entry go'
            e.preventDefault()
            if @props.email_avail and @good_pwd
                @props.signup
                    email_candide: @state.email
                    pwd_candide: @state.password
            @setState
                phase: 'waiting_pending'
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
        input
            style:
                fontStyle: 'italic'
                backgroundColor: 'lightgreen'
                borderRadius: .008 * wh
            value: 'SUBMIT'
            type: 'submit'
            # 'submit'

        unless @good_pwd is null
            p
                style:
                    fontSize: .016 * wh
                    fontStyle: 'italic'
                    color: if @good_pwd then 'lightgreen' else 'magenta'
                if @good_pwd then "ok" else "Password must be at least 7 characters and must match in both fields."


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
            when 'waiting_pending'
                div null, 'waiting pending'


# TODO : websocketts checks for email name availability


check_good_pwd = ({ next_pwd, next_pwd_confirm }) ->
    same_pwds = next_pwd is next_pwd_confirm
    ample_pwd = next_pwd.length > 3
    @good_pwd = do ->
        if next_pwd.length is 0
            null
        else
            same_pwds and ample_pwd


comp = rr

    good_pwd: null

    componentWillUpdate: (nextProps, nextState) ->
        @check_good_pwd
            next_pwd: nextState.password
            next_pwd_confirm: nextState.password_confirm

    check_good_pwd: check_good_pwd

    getInitialState: ->
        phase: 'email_entry'
        password: ''
        password_confirm: ''
        email: ''


    render: render


map_state_to_props = (state) ->
    state.get('tami_index').toJS()


map_dispatch_to_props = (dispatch) ->
    signup: ({ email_candide, pwd_candide }) ->
        dispatch
            type: 'signup'
            payload: { email_candide, pwd_candide }

    check_email_avail: ({ email_candide }) ->
        dispatch
            type: 'check_email_avail'
            payload: { email_candide }



exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
