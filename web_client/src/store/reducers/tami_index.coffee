



api = {}

PREPARE = 'prepare'
IN_PROGRESS = 'in_progress'
COMPLETED = 'completed'
SUBMIT_DATA_JOB_STATUS = 'SUBMIT_DATA_JOB_STATUS'



incoming_effects_api = {}


incoming_effects_api.res_submit_data_form = ({ state, action, data }) ->
    c 'received okay on submit data form'

    state = state.set SUBMIT_DATA_JOB_STATUS, COMPLETED
    state


# concord_channel['dctn_initial_blob'] = ({ state, action, data }) ->
#     state.setIn ['dctn_blob'], data.payload.blob


keys_incoming_effects_api = _.keys incoming_effects_api








api.submit_data_form = ({ state, action }) ->
    state = state.set SUBMIT_DATA_JOB_STATUS, IN_PROGRESS
    state.setIn ['effects', shortid()],
        type: 'submit_data_form'
        payload: action.payload

api['primus:data'] = ({ state, action }) ->
    { data } = action.payload
    { type, payload } = action.payload.data
    if _.includes(keys_incoming_effects_api, type)
        incoming_effects_api[type] { state, action, data }
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
    state = state.setIn ['effects'], Imm.Map({})
    if _.includes(keys_api, action.type)
        api[action.type]({ state, action })
    else
        c 'noop with ', action.type
        state


exports.default = tami_index
