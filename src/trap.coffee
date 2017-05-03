module.exports = (done, scenario) -> (err, res) ->
  [ res, err ] = [ err, undefined ] if arguments.length < 2
  return done err if err?
  try scenario(res) catch err then done err
