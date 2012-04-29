// Generated by CoffeeScript 1.3.1
(function() {
  var e, evaluatableObject;

  evaluatableObject = {
    name: "foo",
    number: 1,
    date: Date.parse('2012-12-21'),
    jsonDate: "2012-12-21T00:00:00.000Z",
    baz: {
      name: "fooBaz"
    },
    bars: [
      {
        name: "bar1",
        number: 1,
        date: Date.parse('2012-12-20'),
        jsonDate: "2012-12-20T00:00:00.000Z"
      }, {
        name: "bar2",
        number: 2,
        date: Date.parse('2012-12-22'),
        jsonDate: "2012-12-22T00:00:00.000Z"
      }
    ]
  };

  e = new Evaluatable(evaluatableObject);

  /*
  
  Note:  While I  have made efforts avoid it, some date tests may fail depending on time zone
  */


  describe("Evaluatable", function() {
    describe("Simple Key Path Query", function() {
      it("returns a single value when addressing a single matching key", function() {
        return expect(e.valueForKeyPath("name")).toEqual("foo");
      });
      it("returns an array when keypath matches multiple keys", function() {
        return expect(e.valueForKeyPath("bars.name").length).toEqual(2);
      });
      it("returns proper array values for multiple matches", function() {
        return expect(e.valueForKeyPath("bars.name")).toEqual(["bar1", "bar2"]);
      });
      return it("returns a single, proper value for nested objects", function() {
        return expect(e.valueForKeyPath("baz.name")).toEqual("fooBaz");
      });
    });
    describe("Built In Operators", function() {
      describe("is", function() {
        it("should compare equal strings properly", function() {
          return expect(e.evaluate("one", "is", "one")).toBeTruthy();
        });
        it("should compare equal numbers properly", function() {
          return expect(e.evaluate(1, "is", 1)).toBeTruthy();
        });
        it("should compare equal numbers properly", function() {
          return expect(e.evaluate(1, "is", "1")).toBeTruthy();
        });
        it("should compare equal dates properly", function() {
          var date, date2;
          date = new Date();
          date2 = date;
          return expect(e.evaluate(date, "is", date2)).toBeTruthy();
        });
        it("should compare inequal strings properly", function() {
          return expect(e.evaluate("one", "is", "2")).toBeFalsy();
        });
        it("should compare inequal numbers properly", function() {
          return expect(e.evaluate(1, "is", 2)).toBeFalsy();
        });
        return it("should compare inequal dates properly", function() {
          var date, date2;
          date = new Date();
          date2 = new Date() + 1000;
          return expect(e.evaluate(date, "is", date2)).toBeFalsy();
        });
      });
      describe("isnt", function() {
        it("should compare equal strings properly", function() {
          return expect(e.evaluate("one", "isnt", "one")).toBeFalsy();
        });
        it("should compare equal numbers properly", function() {
          return expect(e.evaluate(1, "isnt", 1)).toBeFalsy();
        });
        it("should compare equal dates properly", function() {
          var date, date2;
          date = new Date();
          date2 = date;
          return expect(e.evaluate(date, "isnt", date2)).toBeFalsy();
        });
        it("should compare inequal strings properly", function() {
          return expect(e.evaluate("one", "isnt", "two")).toBeTruthy();
        });
        it("should compare inequal numbers properly", function() {
          return expect(e.evaluate(1, "isnt", 2)).toBeTruthy();
        });
        return it("should compare inequal dates properly", function() {
          var date, date2;
          date = new Date();
          date2 = new Date(new Date() + 1000);
          return expect(e.evaluate(date, "isnt", date2)).toBeTruthy();
        });
      });
      describe("isGreaterThan", function() {
        it("should compare strings properly when true is expected", function() {
          return expect(e.evaluate("b", "isGreaterThan", "a")).toBeTruthy();
        });
        it("should compare numbers properly when true is expected", function() {
          return expect(e.evaluate(2, "isGreaterThan", 1)).toBeTruthy();
        });
        it("should compare dates properly when true is expected", function() {
          var date, date2;
          date = new Date();
          date2 = date.getTime() + (3600 * 24 * 1000);
          return expect(e.evaluate(date2, "isGreaterThan", date)).toBeTruthy();
        });
        it("should compare strings properly when false is expected", function() {
          return expect(e.evaluate("a", "isGreaterThan", "b")).toBeFalsy();
        });
        it("should compare numbers properly when false is expected", function() {
          return expect(e.evaluate(1, "isGreaterThan", 2)).toBeFalsy();
        });
        return it("should compare dates properlywhen false is expected", function() {
          var date, date2;
          date = new Date();
          date2 = date.getTime() + (3600 * 24 * 1000);
          console.log(date, date2);
          return expect(e.evaluate(date, "isGreaterThan", date2)).toBeFalsy();
        });
      });
      describe("isLessThan", function() {
        it("should compare strings properly when true is expected", function() {
          return expect(e.evaluate("a", "isLessThan", "b")).toBeTruthy();
        });
        it("should compare numbers properly when true is expected", function() {
          return expect(e.evaluate(1, "isLessThan", 2)).toBeTruthy();
        });
        it("should compare dates properly when true is expected", function() {
          var date, date2;
          date = new Date();
          date2 = date.getTime() + (3600 * 24 * 1000);
          return expect(e.evaluate(date, "isLessThan", date2)).toBeTruthy();
        });
        it("should compare strings properly when false is expected", function() {
          return expect(e.evaluate("b", "isLessThan", "a")).toBeFalsy();
        });
        it("should compare numbers properly when false is expected", function() {
          return expect(e.evaluate(2, "isLessThan", 1)).toBeFalsy();
        });
        return it("should compare dates properlywhen false is expected", function() {
          var date, date2;
          date = new Date();
          date2 = date.getTime() + (3600 * 24 * 1000);
          return expect(e.evaluate(date2, "isLessThan", date)).toBeFalsy();
        });
      });
      describe("startsWith", function() {
        it("should compare strings properly when true is expected", function() {
          return expect(e.evaluate("baz", "startsWith", "b")).toBeTruthy();
        });
        it("should compare numbers properly when true is expected", function() {
          return expect(e.evaluate(21, "startsWith", 2)).toBeTruthy();
        });
        it("should compare dates properly when true is expected", function() {
          var date;
          date = new Date(Date.parse('2012-12-20'));
          return expect(e.evaluate(date, "startsWith", "Wed")).toBeTruthy();
        });
        it("should compare arrays properly and return true if the first element of the array matches the comparator", function() {
          return expect(e.evaluate(["1", "2", "3"], "startsWith", "1")).toBeTruthy();
        });
        it("should compare strings properly when false is expected", function() {
          return expect(e.evaluate("baz", "startsWith", "a")).toBeFalsy();
        });
        it("should compare numbers properly when false is expected", function() {
          return expect(e.evaluate(21, "startsWith", 1)).toBeFalsy();
        });
        it("should compare dates properlywhen false is expected", function() {
          var date;
          date = new Date(Date.parse('2012-12-20'));
          return expect(e.evaluate(date, "startsWith", "Q")).toBeFalsy();
        });
        return it("should compare arrays properly and return false if the first element of the array does not match the comparator", function() {
          return expect(e.evaluate(["3", "2", "1"], "startsWith", "1")).toBeFalsy();
        });
      });
      return describe("contains", function() {
        it("should compare strings properly when true is expected", function() {
          return expect(e.evaluate("baz", "contains", "b")).toBeTruthy();
        });
        it("should compare numbers properly when true is expected", function() {
          return expect(e.evaluate(21, "contains", 2)).toBeTruthy();
        });
        it("should compare dates properly when true is expected", function() {
          var date;
          date = new Date(Date.parse('2012-12-20'));
          return expect(e.evaluate(date, "contains", "2012")).toBeTruthy();
        });
        it("should compare arrays properly and return true if the any elements of the array matches the comparator", function() {
          return expect(e.evaluate(["1", "2", "3"], "contains", "1")).toBeTruthy();
        });
        it("should compare strings properly when false is expected", function() {
          return expect(e.evaluate("baz", "contains", "w")).toBeFalsy();
        });
        it("should compare numbers properly when false is expected", function() {
          return expect(e.evaluate(21, "contains", 3)).toBeFalsy();
        });
        it("should compare dates properlywhen false is expected", function() {
          var date;
          date = new Date(Date.parse('2011-12-20'));
          return expect(e.evaluate(date, "contains", "2012")).toBeFalsy();
        });
        return it("should compare arrays properly and return false if no elements of the array does not match the comparator", function() {
          return expect(e.evaluate(["3", "2", "1"], "contains", "4")).toBeFalsy();
        });
      });
    });
    return describe("Aggregated Comparison", function() {
      describe("any", function() {
        it("should return true when any of the elements evaluates to true", function() {
          expect(e.any("bars.name", "is", "bar1")).toBeTruthy();
          return expect(e.evaluateKeyPath("bars.name:any", "is", "bar1")).toBeTruthy();
        });
        return it("should return false when none of the elements evaluates to true", function() {
          expect(e.any("bars.name", "is", "bar3")).toBeFalsy();
          return expect(e.evaluateKeyPath("bars.name:any", "is", "bar3")).toBeFalsy();
        });
      });
      describe("all", function() {
        it("should return true when all of the elements evaluates to true", function() {
          expect(e.all("bars.name", "startsWith", "bar")).toBeTruthy();
          return expect(e.evaluateKeyPath("bars.name:all", "startsWith", "bar")).toBeTruthy();
        });
        return it("should return false when any of the elements evaluates to false", function() {
          expect(e.all("bars.name", "is", "bar1")).toBeFalsy();
          return expect(e.evaluateKeyPath("bars.name:all", "is", "bar1")).toBeFalsy();
        });
      });
      describe("none", function() {
        it("should return true when none of the elements evaluates to true", function() {
          expect(e.none("bars.name", "is", "bar3")).toBeTruthy();
          return expect(e.evaluateKeyPath("bars.name:none", "is", "bar3")).toBeTruthy();
        });
        return it("should return false when any of the elements evaluates to true", function() {
          expect(e.none("bars.name", "is", "bar1")).toBeFalsy();
          return expect(e.evaluateKeyPath("bars.name:none", "is", "bar1")).toBeFalsy();
        });
      });
      describe("sum", function() {
        it("should return true when the sum all of the elements passes the evaulation", function() {
          expect(e.sum("bars.number", "is", 3)).toBeTruthy();
          return expect(e.evaluateKeyPath("bars.number:sum", "is", 3)).toBeTruthy();
        });
        return it("should return false when the sum of the elements fails the evaulation", function() {
          expect(e.sum("bars.number", "is", 2)).toBeFalsy();
          return expect(e.evaluateKeyPath("bars.number:sum", "is", 2)).toBeFalsy();
        });
      });
      describe("min", function() {
        it("should return true when the minimum all of the elements passes the evaulation", function() {
          expect(e.min("bars.number", "is", 1)).toBeTruthy();
          return expect(e.evaluateKeyPath("bars.number:min", "is", 1)).toBeTruthy();
        });
        return it("should return false when the minimum of the elements fails the evaulation", function() {
          expect(e.min("bars.number", "is", 1)).toBeTruthy();
          return expect(e.evaluateKeyPath("bars.number:min", "is", 1)).toBeTruthy();
        });
      });
      describe("max", function() {
        it("should return true when the maximum all of the elements passes the evaulation", function() {
          expect(e.max("bars.number", "is", 2)).toBeTruthy();
          return expect(e.evaluateKeyPath("bars.number:max", "is", 2)).toBeTruthy();
        });
        return it("should return false when the maximum of the elements fails the evaulation", function() {
          expect(e.max("bars.number", "is", 1)).toBeFalsy();
          return expect(e.evaluateKeyPath("bars.number:max", "is", 1)).toBeFalsy();
        });
      });
      describe("count", function() {
        it("should return true when the sum all of the elements passes the evaulation", function() {
          expect(e.count("bars", "is", 2)).toBeTruthy();
          return expect(e.evaluateKeyPath("bars:count", "is", 2)).toBeTruthy();
        });
        return it("should return false when the sum of the elements fails the evaulation", function() {
          expect(e.count("bars", "isGreaterThan", 3)).toBeFalsy();
          return expect(e.evaluateKeyPath("bars:count", "isGreaterThan", 3)).toBeFalsy();
        });
      });
      return describe("average", function() {
        it("should return true when the sum all of the elements passes the evaulation", function() {
          expect(e.average("bars.number", "is", 1.5)).toBeTruthy();
          return expect(e.evaluateKeyPath("bars.number:average", "is", 1.5)).toBeTruthy();
        });
        return it("should return false when the sum of the elements fails the evaulation", function() {
          expect(e.average("bars.number", "is", 2)).toBeFalsy();
          return expect(e.evaluateKeyPath("bars.number:average", "is", 2)).toBeFalsy();
        });
      });
    });
  });

}).call(this);