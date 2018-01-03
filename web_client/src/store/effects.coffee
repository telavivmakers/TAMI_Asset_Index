arq = {}

# arq = assign arq, require('./side_effects/init.coffee').default


arq = _.assign arq, require('./effects/core.coffee').default


keys_arq = _.keys arq


effects_f = ({ store }) ->
    ({ state_js }) ->
        state = state_js
        for key_id, effect of state.tami_index.effects
            if _.includes(keys_arq, effect.type)
                arq[effect.type] { effect , store }
            else
                c 'no-op with in effects with type', effect.type


exports.default = effects_f
