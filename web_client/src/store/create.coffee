
{
    applyMiddleware, compose, createStore
} = require 'redux'
{ combineReducers } = require 'redux-immutable'
thunk = require('redux-thunk').default
middleware = thunk


tami_index = require('./reducers/tami_index.coffee').default

reducers = { tami_index }

initial_state = require('./initial_state.coffee').default

imm_initial_state = Imm.fromJS(initial_state)

store = createStore(combineReducers(reducers), imm_initial_state, compose(applyMiddleware(middleware)))

effects = require('./effects.coffee').default { store }


effect_trigger_f = ({ store }) ->
    ->
        state_js = store.getState().toJS()
        effects { state_js }

set = effect_trigger_f { store }
store.subscribe set

state_js = imm_initial_state.toJS()
effects { state_js }


module.exports = store
