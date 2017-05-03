{ isPlainObject } = require 'lodash'

module.exports = (defaults) -> (done, request, field, value, error) ->
  body = defaults()
  [ path..., last ] = field.split '.'
  ctx = body
  for node in path
    ctx = ctx[node] ?= {}
  if value is undefined then delete ctx[last] else ctx[last] = value
  json = {}
  if isPlainObject error
    for key, err of error
      it = json[key] = errors: [].concat(err)
      [ first, path... ] = key.split '.'
      continue if first is 'global'
      ctx = value
      for node in path
        ctx = if ctx? then ctx[node] else undefined
      it.value = ctx unless ctx is undefined
  else
    json[field] = errors: [].concat error
    json[field].value = value unless value is undefined
  request
    .type 'json'
    .send body
    .expect 'content-type', /json/
    .expect 422, json, done
  return
