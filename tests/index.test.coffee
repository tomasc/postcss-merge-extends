postcss = require('postcss')
plugin = require('../')

run = (input, output, opts) ->
  postcss([ plugin(opts) ]).process(input).then (result) ->
    expect(result.css).toEqual output
    expect(result.warnings()).toHaveLength 0
    return

# ---------------------------------------------------------------------

it 'extracts placeholders and merges selectors', ->
  input = """
    body {
      /*! placeholder:start %font-size-xs-15 */
      font-size: 1.5rem;
      line-height: 1em;
      /*! placeholder:end */
      background: pink; }

    .foo {
      color: yellow;
      /*! placeholder:start %font-size-xs-15 */
      font-size: 1.5rem;
      line-height: 1em;
      /*! placeholder:end */ }
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

it 'works with multiple', ->
  input = """
    body {
      /*! placeholder:start %font-size-xs-15 */
      font-size: 1.5rem;
      /*! placeholder:end */ }

    .foo {
      color: yellow;
      /*! placeholder:start %font-size-xs-20 */
      font-size: 2rem;
      /*! placeholder:end */ }
  """

  expected = """
  body {
    font-size: 1.5rem; }

  .foo {
    font-size: 2rem; }

  .foo {
    color: yellow; }
  """
  run input, expected, {}
