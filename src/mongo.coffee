async = require 'async'
meerkat = require 'meerkat'

module.exports = (config, app) ->
  
  with_connection = (callback) ->
    return callback app.locals.meerkat if app.locals.meerkat?
    { uri, options } = config
    meerkat.connect app.locals, options, uri, callback

  collection_for = (name, callback) ->
    with_connection (connection) ->
      connection.collection name, callback

  clean = (done) ->
    with_connection (connection) ->
      connection.delegate.collections (junk, collections) ->
        async.each collections,
          (collection, done) ->
            collection.remove {}, done
          done
          
  {
    with_connection
    withConnection: with_connection
    collection_for
    collectionFor: collection_for
    clean
  }
