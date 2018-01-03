owner_model_deprecated = ->
    owner_id: v4()
    record_list: v4() # instead of maintaining separate lists of stuff and slots we could just have one list with records that contain a timestamp, an owner-id, a slot-id, and a stuff string. this way the same records could be stored in the record list of both owners and slots.  In fact, using the lambda-architecture concept, we could just do everything as a list of timestamped records of this type, with the sense and structure provided by a reducer function.
    # We would still have owner hashes and slot hashes, but they
    # wouldn't need to keep references to the stuff records.  They would just need to store identitying and contact information.
