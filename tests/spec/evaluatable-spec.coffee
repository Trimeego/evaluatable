evaluatableObject = 
  name: "foo"  
  number: 1
  date: Date.parse('2012-12-21')
  jsonDate: "2012-12-21T00:00:00.000Z"
  baz: 
    name: "fooBaz"
  bars: [
    name: "bar1"
    number: 1
    date: Date.parse('2012-12-20')
    jsonDate: "2012-12-20T00:00:00.000Z"
  ,
    name: "bar2"
    number: 2
    date: Date.parse('2012-12-22')
    jsonDate: "2012-12-22T00:00:00.000Z"
  ]

e = new Evaluatable(evaluatableObject)

###

Note:  While I  have made efforts avoid it, some date tests may fail depending on time zone

###

describe "Evaluatable", ->
  
  describe "Simple Key Path Query", ->

    it "returns a single value when addressing a single matching key", ->
      expect(e.valueForKeyPath("name")).toEqual("foo")

    it "returns an array when keypath matches multiple keys", ->
      expect(e.valueForKeyPath("bars.name").length).toEqual(2)   

    it "returns proper array values for multiple matches", ->
      expect(e.valueForKeyPath("bars.name")).toEqual(["bar1", "bar2"])          

    it "returns a single, proper value for nested objects", ->
      expect(e.valueForKeyPath("baz.name")).toEqual("fooBaz")

  describe "Built In Operators", ->
    
    describe "is", ->

      it  "should compare equal strings properly", ->
        expect(e.evaluate "one", "is", "one").toBeTruthy()

      it  "should compare equal numbers properly", ->
        expect(e.evaluate 1, "is", 1).toBeTruthy()

      it  "should compare equal numbers properly", ->
        expect(e.evaluate 1, "is", "1").toBeTruthy()

      it  "should compare equal dates properly", ->
        date = new Date()
        date2 = date
        expect(e.evaluate date, "is", date2).toBeTruthy()

      it  "should compare inequal strings properly", ->
        expect(e.evaluate "one", "is", "2").toBeFalsy()

      it  "should compare inequal numbers properly", ->
        expect(e.evaluate 1, "is", 2).toBeFalsy()

      it  "should compare inequal dates properly", ->
        date = new Date()
        date2 = new Date() + 1000
        expect(e.evaluate date, "is", date2).toBeFalsy()


    describe "isnt", ->

      it  "should compare equal strings properly", ->
        expect(e.evaluate "one", "isnt", "one").toBeFalsy()

      it  "should compare equal numbers properly", ->
        expect(e.evaluate 1, "isnt", 1).toBeFalsy()

      it  "should compare equal dates properly", ->
        date = new Date()
        date2 = date
        expect(e.evaluate date, "isnt", date2).toBeFalsy()

      it  "should compare inequal strings properly", ->
        expect(e.evaluate "one", "isnt", "two").toBeTruthy()

      it  "should compare inequal numbers properly", ->
        expect(e.evaluate 1, "isnt", 2).toBeTruthy()

      it  "should compare inequal dates properly", ->
        date = new Date()
        date2 = new Date(new Date() + 1000)
        expect(e.evaluate date, "isnt", date2).toBeTruthy()


    describe "isGreaterThan", ->

      it  "should compare strings properly when true is expected", ->
        expect(e.evaluate "b", "isGreaterThan", "a").toBeTruthy()

      it  "should compare numbers properly when true is expected", ->
        expect(e.evaluate 2, "isGreaterThan", 1).toBeTruthy()

      it  "should compare dates properly when true is expected", ->
        date = new Date()
        date2 = date.getTime() + (3600 * 24 * 1000)
        expect(e.evaluate date2, "isGreaterThan", date).toBeTruthy()

      it  "should compare strings properly when false is expected", ->
        expect(e.evaluate "a", "isGreaterThan", "b").toBeFalsy()

      it  "should compare numbers properly when false is expected", ->
        expect(e.evaluate 1, "isGreaterThan", 2).toBeFalsy()

      it  "should compare dates properlywhen false is expected", ->
        date = new Date()
        date2 = date.getTime() + (3600 * 24 * 1000)
        console.log date, date2
        expect(e.evaluate date, "isGreaterThan", date2).toBeFalsy()

    describe "isLessThan", ->

      it  "should compare strings properly when true is expected", ->
        expect(e.evaluate "a", "isLessThan", "b").toBeTruthy()

      it  "should compare numbers properly when true is expected", ->
        expect(e.evaluate 1, "isLessThan", 2).toBeTruthy()

      it  "should compare dates properly when true is expected", ->
        date = new Date()
        date2 = date.getTime() + (3600 * 24 * 1000)
        expect(e.evaluate date, "isLessThan", date2).toBeTruthy()

      it  "should compare strings properly when false is expected", ->
        expect(e.evaluate "b", "isLessThan", "a").toBeFalsy()

      it  "should compare numbers properly when false is expected", ->
        expect(e.evaluate 2, "isLessThan", 1).toBeFalsy()

      it  "should compare dates properlywhen false is expected", ->
        date = new Date()
        date2 = date.getTime() + (3600 * 24 * 1000)
        expect(e.evaluate date2, "isLessThan", date).toBeFalsy()

    describe "startsWith", ->

      it  "should compare strings properly when true is expected", ->
        expect(e.evaluate "baz", "startsWith", "b").toBeTruthy()

      it  "should compare numbers properly when true is expected", ->
        expect(e.evaluate 21, "startsWith", 2).toBeTruthy()

      it  "should compare dates properly when true is expected", ->
        date = new Date(Date.parse('2012-12-20'))
        expect(e.evaluate date, "startsWith", "Wed").toBeTruthy()

      it  "should compare arrays properly and return true if the first element of the array matches the comparator", ->
        expect(e.evaluate ["1", "2", "3"], "startsWith", "1").toBeTruthy()

      it  "should compare strings properly when false is expected", ->
        expect(e.evaluate "baz", "startsWith", "a").toBeFalsy()

      it  "should compare numbers properly when false is expected", ->
        expect(e.evaluate 21, "startsWith", 1).toBeFalsy()

      it  "should compare dates properlywhen false is expected", ->
        date = new Date(Date.parse('2012-12-20'))
        expect(e.evaluate date, "startsWith", "Q").toBeFalsy()

      it  "should compare arrays properly and return false if the first element of the array does not match the comparator", ->
        expect(e.evaluate ["3", "2", "1"], "startsWith", "1").toBeFalsy()

    describe "contains", ->

      it  "should compare strings properly when true is expected", ->
        expect(e.evaluate "baz", "contains", "b").toBeTruthy()

      it  "should compare numbers properly when true is expected", ->
        expect(e.evaluate 21, "contains", 2).toBeTruthy()

      it  "should compare dates properly when true is expected", ->
        date = new Date(Date.parse('2012-12-20'))
        expect(e.evaluate date, "contains", "2012").toBeTruthy()

      it  "should compare arrays properly and return true if the any elements of the array matches the comparator", ->
        expect(e.evaluate ["1", "2", "3"], "contains", "1").toBeTruthy()

      it  "should compare strings properly when false is expected", ->
        expect(e.evaluate "baz", "contains", "w").toBeFalsy()

      it  "should compare numbers properly when false is expected", ->
        expect(e.evaluate 21, "contains", 3).toBeFalsy()

      it  "should compare dates properlywhen false is expected", ->
        date = new Date(Date.parse('2011-12-20'))
        expect(e.evaluate date, "contains", "2012").toBeFalsy()

      it  "should compare arrays properly and return false if no elements of the array does not match the comparator", ->
        expect(e.evaluate ["3", "2", "1"], "contains", "4").toBeFalsy()      


  describe "Aggregated Comparison", ->
    
    describe "any", ->

      it  "should return true when any of the elements evaluates to true", ->
        expect(e.any("bars.name", "is", "bar1")).toBeTruthy()
        expect(e.evaluateKeyPath("bars.name:any", "is", "bar1")).toBeTruthy()

      it  "should return false when none of the elements evaluates to true", ->
        expect(e.any("bars.name", "is", "bar3")).toBeFalsy()
        expect(e.evaluateKeyPath("bars.name:any", "is", "bar3")).toBeFalsy()


    describe "all", ->

      it  "should return true when all of the elements evaluates to true", ->
        expect(e.all("bars.name", "startsWith", "bar")).toBeTruthy()
        expect(e.evaluateKeyPath("bars.name:all", "startsWith", "bar")).toBeTruthy()


      it  "should return false when any of the elements evaluates to false", ->
        expect(e.all("bars.name", "is", "bar1")).toBeFalsy()
        expect(e.evaluateKeyPath("bars.name:all", "is", "bar1")).toBeFalsy()


    describe "none", ->

      it  "should return true when none of the elements evaluates to true", ->
        expect(e.none("bars.name", "is", "bar3")).toBeTruthy()
        expect(e.evaluateKeyPath("bars.name:none", "is", "bar3")).toBeTruthy()

      it  "should return false when any of the elements evaluates to true", ->
        expect(e.none("bars.name", "is", "bar1")).toBeFalsy()
        expect(e.evaluateKeyPath("bars.name:none", "is", "bar1")).toBeFalsy()


    describe "sum", ->

      it  "should return true when the sum all of the elements passes the evaulation", ->
        expect(e.sum("bars.number", "is", 3)).toBeTruthy()
        expect(e.evaluateKeyPath("bars.number:sum", "is", 3)).toBeTruthy()

      it  "should return false when the sum of the elements fails the evaulation", ->
        expect(e.sum("bars.number", "is", 2)).toBeFalsy()
        expect(e.evaluateKeyPath("bars.number:sum", "is", 2)).toBeFalsy()


    describe "min", ->

      it  "should return true when the minimum all of the elements passes the evaulation", ->
        expect(e.min("bars.number", "is", 1)).toBeTruthy()
        expect(e.evaluateKeyPath("bars.number:min", "is", 1)).toBeTruthy()

      it  "should return false when the minimum of the elements fails the evaulation", ->
        expect(e.min("bars.number", "is", 1)).toBeTruthy()
        expect(e.evaluateKeyPath("bars.number:min", "is", 1)).toBeTruthy()


    describe "max", ->

      it  "should return true when the maximum all of the elements passes the evaulation", ->
        expect(e.max("bars.number", "is", 2)).toBeTruthy()
        expect(e.evaluateKeyPath("bars.number:max", "is", 2)).toBeTruthy()

      it  "should return false when the maximum of the elements fails the evaulation", ->
        expect(e.max("bars.number", "is", 1)).toBeFalsy()
        expect(e.evaluateKeyPath("bars.number:max", "is", 1)).toBeFalsy()

    describe "count", ->

      it  "should return true when the sum all of the elements passes the evaulation", ->
        expect(e.count("bars", "is", 2)).toBeTruthy()
        expect(e.evaluateKeyPath("bars:count", "is", 2)).toBeTruthy()

      it  "should return false when the sum of the elements fails the evaulation", ->
        expect(e.count("bars", "isGreaterThan", 3)).toBeFalsy()
        expect(e.evaluateKeyPath("bars:count", "isGreaterThan", 3)).toBeFalsy()


    describe "average", ->

      it  "should return true when the sum all of the elements passes the evaulation", ->
        expect(e.average("bars.number", "is", 1.5)).toBeTruthy()
        expect(e.evaluateKeyPath("bars.number:average", "is", 1.5)).toBeTruthy()

      it  "should return false when the sum of the elements fails the evaulation", ->
        expect(e.average("bars.number", "is", 2)).toBeFalsy()
        expect(e.evaluateKeyPath("bars.number:average", "is", 2)).toBeFalsy()



