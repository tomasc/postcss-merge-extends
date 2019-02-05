postcss = require('postcss')


module.exports = postcss.plugin 'postcss-merge-extends', (opts) ->
  opts = opts or {}
  (root, result) ->
    for name in getPlaceholderNames(root)
      if commentNode = getFirstPlaceholderCommentNode(root, name)
        placeholderContent = getPlaceholderContent(commentNode)
        placeholderSelectors = getPlaceholderSelectors(root, name)
        newNode = commentNode.parent.clone()
        newNode.selector = placeholderSelectors.join(', ')
        newNode.removeAll()
        newNode.append(rule) for rule in placeholderContent
        commentNode.parent.before(newNode)

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
    if hasPlaceholderName(comment, name) && res == null
      res = comment
      return
  res

getPlaceholderSelectors = (root, name) ->
  res = []
  root.walkComments (comment) ->
    if hasPlaceholderName(comment, name)
      res.push comment.parent.selector
  res

getPlaceholderContent = (node) ->
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
