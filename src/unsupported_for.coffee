{ difference } = require 'lodash'

module.exports = (request, path, supported...) ->
  supported.push 'head' if 'get' in supported unless 'head' in supported
  verbs = [ 'get', 'post', 'put', 'patch', 'delete', 'options', 'head' ]
  unsupported = difference verbs, supported
  describe 'unsupported verbs', ->
    for verb in unsupported
      describe verb.toUpperCase(), ->
        it 'should identifiy that this method is not allowed', (done) ->
          request[verb] path
            .expect 'allow', supported.join(', ').toUpperCase()
            .expect 405, done
          return
