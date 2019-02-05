postcss = require('postcss')
plugin = require('../')

run = (input, output, opts) ->
  postcss([ plugin(opts) ]).process(input).then (result) ->
    expect(result.css).toEqual output
    expect(result.warnings()).toHaveLength 0
    return

# ---------------------------------------------------------------------

it 'extracts placeholders', ->
  input = """
    body {
      /*! extend:start %font-size-xs-15 */
      font-size: 1.5rem;
      line-height: 1em;
      /*! extend:end */
      background: pink; }

    .foo {
      color: yellow;
      /*! extend:start %font-size-xs-15 */
      font-size: 1.5rem;
      line-height: 1em;
      /*! extend:end */ }
  """

  expected = """
  body, .foo {
    font-size: 1.5rem;
    line-height: 1em; }

  body {
    background: pink; }

  .foo {
    color: yellow; }
  """
  run input, expected, {}
