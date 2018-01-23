

PREPARE = 'prepare'
IN_PROGRESS = 'in_progress'
COMPLETED = 'completed'
SUBMIT_DATA_JOB_STATUS = 'SUBMIT_DATA_JOB_STATUS'

exports.default =
    tami_index:
        # jobs: Imm.Map({})









        hash_location: 'ufo'






        SUBMIT_DATA_JOB_STATUS: PREPARE
        effects : Imm.Map
            "#{shortid()}":
                type: 'init_primus'
            "#{shortid()}":
                type: 'setup_listen_location'
