






api = {}

PREPARE = 'prepare'
IN_PROGRESS = 'in_progress'
COMPLETED = 'completed'
SUBMIT_DATA_JOB_STATUS = 'SUBMIT_DATA_JOB_STATUS'



incoming_effects_api = {}


incoming_effects_api.res_submit_data_form = ({ state, action, data, store }) ->
    c 'received okay on submit data form'

    state = state.set SUBMIT_DATA_JOB_STATUS, COMPLETED

    setTimeout =>
        store.dispatch
            type: 'set_submit_form_prepare'
    , 2500

    state


# concord_channel['dctn_initial_blob'] = ({ state, action, data }) ->
#     state.setIn ['dctn_blob'], data.payload.blob


keys_incoming_effects_api = _.keys incoming_effects_api




api.set_submit_form_prepare = ({ state, action }) ->
    state.set SUBMIT_DATA_JOB_STATUS, PREPARE




api.submit_data_form = ({ state, action }) ->
    state = state.set SUBMIT_DATA_JOB_STATUS, IN_PROGRESS
    state.setIn ['effects', shortid()],
        type: 'submit_data_form'
        payload: action.payload















api.signup = ({ state, action }) ->
    state = state.set 'signup_status', 'sending'
    state = state.setIn ['effects', shortid()],
        type: 'signup'
        payload: action.payload
    state



api.res_check_email_avail = ({ state, action }) ->
    state = state.set 'email_avail', action.payload
    state

api.check_email_avail = ({ state, action }) ->
    state = state.setIn ['effects', shortid()],
        type: 'check_email_avail'
        payload: action.payload
    state


api.hash_location_change = ({ state, action  }) ->
    state.set 'hash_location', action.payload.location


api['primus:data'] = ({ state, action }) ->
    { data, store } = action.payload
    { type, payload } = action.payload.data
    if _.includes(keys_incoming_effects_api, type)
        incoming_effects_api[type] { state, action, data, store }
    else
        state


# these that require primus write sideeffects can be
# handled by a single function from now on so additions
# should require code edits in fewer places.
api['primus_hotwire'] = ({ state, action }) ->
    state.setIn ['effects', shortid()],
        type: 'primus_hotwire'
        payload: action.payload


# arq['search_struct'] = ({ state, action }) ->
#     state.setIn ['desires', shortid()],
#         type: 'search_struct_nodemem'
#         payload: action.payload





keys_api = _.keys api


tami_index = (state, action) ->
    # c arguments
    # c 'store', store
    # c 'dispatch', dispatch
    state = state.setIn ['effects'], Imm.Map({})
    if _.includes(keys_api, action.type)
        api[action.type]({ state, action })
    else
        c 'reducer noop with ', action.type
        state


exports.default = tami_index
