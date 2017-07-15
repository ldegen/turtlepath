module.exports = (vertices)->

  mod = (n, k)->
    if n*k < 0 then n + (k%n) else k%n

  pick = (arr,i) -> arr[limit(arr,i)]
  limit = (arr,i) -> mod(arr.length,i)

  initialState: [0,0]
  position: ([vi])->
    pick(vertices, vi).position
  move: ([vi, ai])->
    source = pick(vertices, vi)
    targetId = pick(source.adjacents, ai)
    target = pick(vertices, targetId)
    [ targetId, limit(target.adjacents, ai)]
  left: ([vi, ai])->
    v = pick(vertices, vi)
    [vi, limit(v.adjacents, ai-1)]
  right: ([vi, ai])->
    v = pick(vertices, vi)
    [vi, limit(v.adjacents, ai+1)]
