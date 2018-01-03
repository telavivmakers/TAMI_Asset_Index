exports.default =
    tami_index:
        # jobs: Imm.Map({})

        effects : Imm.Map
            "#{shortid()}":
                type: 'init_primus'
