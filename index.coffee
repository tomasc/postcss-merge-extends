postcss = require('postcss')


module.exports = postcss.plugin 'postcss-merge-extends', (opts) ->
  opts = opts or {}
  (root, result) ->
    for name in getPlaceholderNames(root)
      console.log name
      if commentNode = getFirstPlaceholderCommentNode(root, name)
        # console.log commentNode
        console.log getPlaceholderRules(commentNode).length
    return

isExtendStart = (node) ->
  return unless node.type is 'comment'
  /extend\:start/.test(node.text)

isExtendEnd = (node) ->
  return unless node.type is 'comment'
  /extend\:end/.test node.text

hasPlaceholderName = (node, name) ->
  return unless isExtendStart(node)
  new RegExp(name).test node.text

getPlaceholderName = (node) ->
  return unless isExtendStart(node)
  node.text.split('%')[1]

getFirstPlaceholderCommentNode = (root, name) ->
  res = null
  root.walkComments (comment) ->
    res = comment if hasPlaceholderName(comment, name)
    return res if res
  res

# getPlaceholderSelector = (node) ->
#   return unless isExtendStart(node)
#   node.parent.selector

getPlaceholderRules = (node) ->
  return unless isExtendStart(node)
  res = []
  nextNode = node.next()
  while nextNode && !isExtendEnd(nextNode)
    res.push nextNode
    nextNode = nextNode.next()
  res

getPlaceholderNames = (root) ->
  res = []
  root.walkComments (comment) ->
    if isExtendStart(comment)
      name = getPlaceholderName(comment)
      res.push(name) unless name in res
  res
