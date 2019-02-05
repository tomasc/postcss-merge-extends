postcss = require('postcss')
plugin = require('../')

run = (input, output, opts) ->
  postcss([ plugin(opts) ]).process(input).then (result) ->
    expect(result.css).toEqual output
    expect(result.warnings()).toHaveLength 0
    return

# ---------------------------------------------------------------------

it 'does something', ->
  run 'a{ }', 'a{ }', {}
