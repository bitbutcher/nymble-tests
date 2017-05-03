{ isFunction } = require 'lodash'
{ errors } = require 'nymble-utils'
trap = require './trap'

success = (code) -> (done, request, verifier) ->
  req = request.expect 'content-type', /json/
  if isFunction verifier
    req.expect(code).end trap done, verifier
  else
    req.expect code, verifier, done
  return

failure = (code, defaults) -> (done, request, verifier) ->
  req = request.expect 'content-type', /json/
  if isFunction verifier
    req.expect(code).end trap done, verifier
  else
    req.expect code, errors.normalize(verifier ? defaults), done
  return

module.exports =

  OK: success 200

  Created: success 201

  Unauthorized:  (done, realm, request, errs) ->
    request
      .expect 'www-authenticate', "Basic realm=\"#{realm}\""
      .expect 'content-type', /json/
      .expect 401, errors.normalize(errs ? 'Unauthorized'), done

  Forbidden: failure 403, 'Forbidden'

  NotFound: failure 404, 'Not Found'

  NotAcceptable: failure 406, "The client must accept content of type 'application/json'."

  Conflict: failure 409, 'Conflict'

  UnsupportedMediaType: failure 415, "The client must send content of type 'application/json'."

  UnprocessableEntity: failure 422, 'Unprocessable Entity'
