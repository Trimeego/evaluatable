### 

_.flatten in the only dependency on underscore, making local reference that 
here so it can be easily replaced.

###

_flatten = _.flatten

matchType = (a, b) ->
  ret = b
  if a.constructor.name isnt b.constructor.name
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
        ret


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
      console.log "condition all" 
      console.log returns
      return (ret for ret in returns when not ret).length is 0


window.Evaluatable = Evaluatable