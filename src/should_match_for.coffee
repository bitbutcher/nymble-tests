{ expect } = require 'chai'
jsonify = require './jsonify'
trap = require './trap'

module.exports = (verify, collection) -> (done, request, keys...) ->
  request
    .expect 'content-type', /json/
    .expect 200
    .end trap done, (res) ->
      expect(res.body.pagination).to.deep.equal page: 1, pages: 1, per: 100, total: keys.length
      for index, key of keys
        for actuals, expecteds of collection()
          verify res.body[actuals][index], jsonify expecteds[key]
      done()
  return
