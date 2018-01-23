

bcrypt = require 'bcrypt-nodejs'

owner_book = 'OWNER_BOOK'
slot_book = 'SLOT_BOOK'

record_list = 'RECORD_LIST'

# NOTE inconsistent capitalisation of string constants between
# client and server side


index_api = {}


owner_model = ({ owner_name }) ->
    id: v4()
    timestamp: Date.now()
    owner_name: owner_name # same as that used in the owner book
    identifying_information: ''

slot_model = ({ slot_name }) ->
    id: v4()
    timestamp: Date.now()
    slot_name: slot_name
    identifying_information: ''


record_model = ({ owner_id, slot_id, stuff }) ->
    id: v4()
    timestamp: Date.now()
    slot_id: slot_id
    owner_id: owner_id
    stuff: stuff


get_make_owner = Bluebird.promisify ({ owner_name }, cb0) ->
    redis.hexistsAsync owner_book, owner_name
    .then (res0) ->
        if res0 is 0
            owner = owner_model { owner_name }
            flow.parallel [
                (cb1) ->
                    redis.hsetAsync owner_book, owner_name, owner.id
                    .then (res1) ->
                        cb1 null, owner.id
                (cb1) ->
                    redis.hmsetAsync owner.id, owner
                    .then (err, res1) ->
                        cb1 null, res1 # todo err handling
            ], (err3, res8) ->
                cb0 null, owner.id
        else
            redis.hgetAsync owner_book, owner
            .then (owner_id) ->
                cb0 null, owner_id


    # redis.hgetAsync owner_book, owner

get_make_slot = Bluebird.promisify ({ slot_name }, cb0) ->
    redis.hexistsAsync slot_book, slot_name
    .then (res0) ->
        if res0 is 0
            slot = slot_model { slot_name }
            flow.parallel [
                (cb1) ->
                    redis.hsetAsync slot_book, slot_name, slot.id
                    .then (res1) ->
                        cb1 null, slot.id
                (cb1) ->
                    redis.hmsetAsync slot.id, slot
                    .then (res1) ->
                        cb1 null, slot.id
            ], (err, res4) ->
                cb0 null, slot.id
        else
            redis.hgetAsync slot_book, slot_name
            .then (slot_id) ->
                cb0 null, slot_id


index_api.submit_data_form = ({ payload, spark }) ->
    { slot_name, owner_name, stuff } = payload
    # timestamp = Date.now()
    # does the owner exist ? if not then create
    # otherwise need to get their hash id
    # does the slot exist ? if not then create
    # either way get the hash id
    flow.parallel [
        (cb) ->
            get_make_owner { owner_name }
            .then (owner_id) ->
                cb null, owner_id
        (cb) ->
            get_make_slot { slot_name }
            .then (slot_id) ->
                cb null, slot_id
    ], (err, res) ->
        c 'have results from parallel', res
        [ owner_id, slot_id ] = res

        record = record_model { owner_id, slot_id, stuff }

        flow.parallel [
            (cb5) ->
                redis.hmsetAsync record.id, record
                .then (err8, res8) ->
                    cb5 null, res8
            (cb5) ->
                redis.lpushAsync record_list, record.id
                .then (err8, res8) ->
                    cb5 null, res8
        ], (err3, res3) ->
            # todo err handle

            # setTimeout ->
            spark.write
                type: 'res_submit_data_form'
                payload:
                    status: 'OK'
            # , 2000



        # redis.hsetAsync owner_id, 'stuff', stuff
        # redis.hsetAsync slot_id, 'stuff', stuff
        # redis.hsetAsync owner_id, 'slot', slot_id
        # redis.hsetAsync slot_id, 'owner', owner_id
        # add stuff to owner-hash and slot-hash
        # add owner to slot-hash
        # add slot to owner-hash

        # That's really simplistic.  Actually we want non-destructive updates, so we'll be adding to a list in a timestamped way.
        # We need to setup the data structures in the get_make








index_api.signup = ({ payload, spark }) ->
    { email_candide, pwd_candide } = payload
    uid = v4()
    bcrypt.genSalt 10, (err, salt) ->
        if err then c err else
            bcrypt.hash pwd_candide, salt
            , ->
                # a pointless progress cb
            , (err2, hash) ->
                if err2 then c err2 else
                    user_arq =
                        uid: uid
                        email: email_candide
                        hash: hash

                    flow.parallel [
                        (cb5) ->
                            redis.hsetAsync 'users_index_by_email', user_arq.email, user_arq.uid
                            .then (res4) ->
                                cb5 null, 'done'

                        (cb5) ->
                            redis.hmsetAsync user_arq.uid, user_arq
                            .then (res5) ->
                                cb5 null, 'done'
                    ], (err7, res7) ->
                        if err7 then c err7 else
                            spark.write
                                type: 'res_signup'
                                payload:
                                    status: 'SUCCESS'
                                    email: user_arq.email




index_api.check_email_avail = ({ payload, spark }) ->
    redis.hexistsAsync 'users_index_by_email', payload.email_candide
    .then (re) ->
        if re is 0
            spark.write
                type: 'res_check_email_avail'
                payload: true
        else
            spark.write
                type: 'res_check_email_avail'
                payload: false



index_api.request_orient = ({ payload, spark }) ->
    c 'request orient payload', payload
    # spark.write 'hi there requesting orient.'






index_api.lookahead = ({ payload, spark }) ->
    c color.red('lookahead', on)
    c payload





index_api.signin = ({ payload, spark }) ->





keys_index_api = _.keys index_api
exports.default = ({ type, payload, spark }) ->
    if _.includes keys_index_api, type
        index_api[type] { payload, spark }
    else
        c color.yellow("no-op in index-api with type", on), color.cyan(type, on)






# REDIS SETUP
redis.hset 'users_index_by_email', '1@1', 'placeholder', (err, re) ->
    c 'setup users index by email'
