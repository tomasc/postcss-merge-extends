postcss = require('postcss')
module.exports = postcss.plugin('postcss-merge-extends', (opts) ->
  opts = opts or {}
  # Work with options here
  (root, result) ->
    # Transform CSS AST here
    return
)
