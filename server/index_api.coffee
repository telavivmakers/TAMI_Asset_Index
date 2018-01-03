



owner_book = 'OWNER_BOOK'
slot_book = 'SLOT_BOOK'



index_api = {}


owner_model = ->
    owner_id: v4()
    record_list: v4() # instead of maintaining separate lists of stuff and slots we could just have one list with records that contain a timestamp, an owner-id, a slot-id, and a stuff string. this way the same records could be stored in the record list of both owners and slots.  In fact, using the lambda-architecture concept, we could just do everything as a list of timestamped records of this type, with the sense and structure provided by a reducer function.
    # We would still have owner hashes and slot hashes, but they
    # wouldn't need to keep references to the stuff records.  They would just need to store identitying and contact information.

slot_model = ->
    slot_id: v4()






get_make_owner_id = Bluebird.promisify ({ owner }, cb) ->
    redis.hexistsAsync owner_book, owner
    .then (res0) ->
        if res0 is 0
            owner_id = v4()
            flow.parallel [
                (cb) ->
                    redis.hsetAsync owner_book, owner, owner_id
                    .then (res1) ->
                        cb null, owner_id
                (cb) ->
                    redis.hmsetAsync

            ], (err, res3) ->


        else
            redis.hgetAsync owner_book, owner
            .then (res2) ->
                cb null, res2


    # redis.hgetAsync owner_book, owner

get_make_slot_id = Bluebird.promisify ({ slot }, cb) ->
    redis.hexistsAsync slot_book, slot
    .then (res0) ->
        if res0 is 0
            slot_id = v4()
            redis.hsetAsync slot_book, slot, slot_id
            .then (res1) ->
                cb null, slot_id
        else
            redis.hgetAsync slot_book, slot
            .then (res2) ->
                cb null, res2


index_api.submit_data_form = ({ payload, spark }) ->
    { slot, owner, stuff } = payload
    timestamp = Date.now()
    # does the owner exist ? if not then create
    # otherwise need to get their hash id
    # does the slot exist ? if not then create
    # either way get the hash id
    flow.parallel [
        (cb) ->
            get_make_owner_id { owner }
            .then (owner_id) ->
                cb null, owner_id
        (cb) ->
            get_make_slot_id { slot }
            .then (slot_id) ->
                cb null, slot_id
    ], (err, res) ->
        c 'have results from parallel', res
        [ owner_id, slot_id ] = res

        redis.hsetAsync owner_id, 'stuff', stuff
        redis.hsetAsync slot_id, 'stuff', stuff
        redis.hsetAsync owner_id, 'slot', slot_id
        redis.hsetAsync slot_id, 'owner', owner_id
        # add stuff to owner-hash and slot-hash
        # add owner to slot-hash
        # add slot to owner-hash

        # That's really simplistic.  Actually we want non-destructive updates, so we'll be adding to a list in a timestamped way.
        # We need to setup the data structures in the get_make















index_api.request_orient = ({ payload, spark }) ->
    c 'request orient payload', payload
    # spark.write 'hi there requesting orient.'






index_api.lookahead = ({ payload, spark }) ->
    c color.red('lookahead', on)
    c payload



keys_index_api = _.keys index_api




















exports.default = ({ type, payload, spark }) ->
    if _.includes keys_index_api, type
        index_api[type] { payload, spark }
    else
        c color.yellow("no-op in index-api with type", on), color.cyan(type, on)
