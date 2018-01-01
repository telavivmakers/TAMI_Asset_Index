








index_api = {}


index_api.request_orient = ({ payload, spark }) ->
    c 'payload', payload
    spark.write 'hi there requesting orient.'








keys_index_api = _.keys index_api




















exports.default = ({ type, payload, spark }) ->
    if _.includes keys_index_api, type
        index_api[type] { payload, spark }
    else
        c color.yellow("no-op in index-api with type", on), color.cyan(type, on)
