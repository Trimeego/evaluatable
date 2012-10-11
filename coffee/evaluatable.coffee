((name, definition) ->
  if typeof define is "function"
    define definition
  else if typeof module isnt "undefined" and module.exports
    module.exports = definition()
  else
    theModule = definition()
    global = this
    old = global[name]
    theModule.noConflict = ->
      global[name] = old
      theModule

    global[name] = theModule
) "Evaluatable", ->


  ### 

  _.flatten in the only dependency on underscore, making local reference that 
  here so it can be easily replaced.

  ###
  if false 
    _flatten = _.flatten
  else
    #this is a small subset of the functioanlity provide by underscore just to support flatten
    ArrayProto = Array.prototype
    nativeForEach = ArrayProto.forEach
    nativeReduce = ArrayProto.reduce
    
    _bind = (func, obj) ->
      args = _.rest arguments, 2
      -> func.apply obj or root, args.concat arguments

    _isArray = Array.isArray or (obj) -> !!(obj and obj.concat and obj.unshift and not obj.callee)
    _isNumber    = (obj) -> (obj is +obj) or toString.call(obj) is '[object Number]'
    _each = (obj, iterator, context) ->
      try
        if nativeForEach and obj.forEach is nativeForEach
          obj.forEach iterator, context
        else if _isNumber obj.length
          iterator.call context, obj[i], i, obj for i in [0...obj.length]
        else
          iterator.call context, val, key, obj  for own key, val of obj
      catch e
        throw e if e isnt breaker
      obj

    _reduce = (obj, iterator, memo, context) ->
      if nativeReduce and obj.reduce is nativeReduce
        iterator = _bind iterator, context if context
        return obj.reduce iterator, memo
      _each obj, (value, index, list) ->
        memo = iterator.call context, memo, value, index, list
      memo

    _flatten = (array) ->
      _reduce array, (memo, value) ->
        return memo.concat(_flatten(value)) if _isArray value
        memo.push value
        memo
      , []


  matchType = (a, b) ->
    ret = b
    if a and b and (a.constructor.name isnt b.constructor.name)
      switch a.constructor.name
        when "Number"
          n = Number(b)
          if n
            ret = n
        when "Date"
          dt = Date.parse(b)
          if dt
            ret = new Date(dt)

    ret


  class Evaluatable
    constructor: (base) ->
      @super = base
      @evaluatables = 
        today: ->
          new Date()
        now: ->
          new Date()


    valueForKeyPath: (key) =>
      if key and key.split
        levels = key.split "."
        root = levels[0]
        if root and root is 'evaluatable'
          nextLevel = levels[1..].join('.')
          # this is an item that evaluates to a named value, such as "today"
          @evaluatables[nextLevel].call()  
        else  
          ret = @kvc(key, @super)    
          if ret and ret.constructor.name is "Array"
            _flatten(ret)
          else
            if not ret
              null
            else
              ret
      else
        null

    kvc: (key, object, lvl) =>
      lvl ?= 1

      levels = key.split "."
      root = object[levels[0]]
      if root
        nextLevel = levels[1..].join('.')
        if levels.length is 1
          root
        else
          switch root.constructor.name
            when "Array"
              (@kvc(nextLevel, item, lvl+1) for item in root)

            when "Object"
              @kvc nextLevel, root, lvl+1
      else
        null



    operators: 
      is: (a,b) => 
        a is matchType(a,b)
      
      isnt: (a,b) => 
        a isnt matchType(a,b)
      
      isLessThan: (a,b) => 
        a < matchType(a,b)
      
      isGreaterThan: (a,b) => 
        a > matchType(a,b)

      startsWith: (a,b) =>
        if a.constructor.name is "Array"

          if a.length > 0 
            if a[0] is matchType(a[0],b)
              return true
        else
          if a.toString().indexOf(b.toString()) is 0
            return true

        return false

      contains: (a,b) =>
        if a.constructor.name is "Array"
          if (item for item in a when item is matchType(item,b)).length>0
            return true
        else
          if a.toString().indexOf(b) > -1
            return true

        return false


    evaluate: (a, operator, b) =>
      op = @operators[operator]
      if op
        op(a, b)
      else
        false

    evaluateKeyPath: (keyPath, operator, value2) =>
      [key, aggregator] = keyPath.split ':'
      if aggregator and @[aggregator]
        @[aggregator].apply @, [key, operator, value2]
      else
        op = @operators[operator]
        if op
          op(@valueForKeyPath(keyPath), value2)
        else
          false

    any: (keyPath, operator, value) =>
      arr = @valueForKeyPath(keyPath)
      for item in arr
        if @evaluate(item, operator, value) 
          return true 

      false

    all:  (keyPath, operator, value) =>
      arr = @valueForKeyPath(keyPath)
      for item in arr
        if not @evaluate(item, operator, value) 
          return false 

      true

    none:  (keyPath, operator, value) =>
      arr = @valueForKeyPath(keyPath)
      for item in arr
        if @evaluate(item, operator, value) 
          return false 

      true

    sum: (keyPath, operator, value) =>
      arr = @valueForKeyPath(keyPath)
      total = 0
      total += item for item in arr
      @evaluate(total, operator, value) 

    min: (keyPath, operator, value) =>
      arr = @valueForKeyPath(keyPath)
      min = null
      min = item for item in arr when not min or min > item
      @evaluate(min, operator, value) 

    max: (keyPath, operator, value) =>
      arr = @valueForKeyPath(keyPath)
      max = null
      max = item for item in arr when not max or max < item
      @evaluate(max, operator, value) 

    count: (keyPath, operator, value) =>
      arr = @valueForKeyPath(keyPath)
      @evaluate(arr.length, operator, value) 

    average: (keyPath, operator, value) =>
      arr = @valueForKeyPath(keyPath)
      total = 0
      total += item for item in arr
      @evaluate(total/arr.length, operator, value) 


    evaluateConditionSet: (conditionSet) =>
      returns = []
      for condition in conditionSet.conditions
        if condition.hasOwnProperty("conditions")
          returns.push @evaluateConditionSet(condition)
        else
          testValue = @valueForKeyPath(condition.value) ? condition.value
          returns.push @evaluateKeyPath(condition.property, condition.operator, testValue)

      if conditionSet.aggregator is "any"
        return (ret for ret in returns when ret).length > 0
      else
        return (ret for ret in returns when not ret).length is 0


  Evaluatable