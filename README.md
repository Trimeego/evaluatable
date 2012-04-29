# Evaluatable


Evaluatable is a javascript module for evaluating deeply nested JSON objects.  The key idea of which is to use key paths to get either single values of value arrays from an object.  These values can then be compared using built-in operators.

## Using the Evaluatable module

Using Evaluatable is as easy as inititalizing a new Evaluatable object using the target object.

### In the browser

    <script type="text/javascript" src="evaluatable.js"></script>

    <script type="text/javascript">
      (function() {

        // Initialize here

      })();
    </script>



### In Node JS

    Evaluatable = require("evaluatable")


### Initializing an Enumerable Object

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


## Getting values Using Key Paths

Accessing values via key path is simple.  Using the object outlined in the example above:

      e.valueForKeyPath("name");
      >> "foo"

      e.valueForKeyPath("baz.name")
      >> "fooBaz"

Values in nested arrays or children of arrays will return a flattened array with all values matching the key path

      e.valueForKeyPath("bars.name")
      >> ["bar1", "bar2"])          






## Using Built-in Operators

In order to provide a few simple built-in operators the Evaluatable module contains several built-in operators that can be used as part of the evaluate method.


### is

    e.evaluate("one", "is", "one");
    >> true

    e.evaluate(1, "is", 1)
    >> true


evaluations will even attempt to reconcile type differences for you

    e.evaluate(1, "is", "1")
    >> true


### isnt

    e.evaluate("one", "isnt", "two");
    >> true

    e.evaluate(1, "isnt", 1)
    >> true


### isGreaterThan

    e.evaluate("b", "isGreaterThan", "a")
    >> true

    e.evaluate(2, "isGreaterThan", 1)
    >> true

    date = new Date()
    date2 = date.getTime() + (3600 * 24 * 1000)
    e.evaluate(date2, "isGreaterThan", date)
    >> true


### isLessThan

    e.evaluate("a", "isLessThan", "b")
    >> true

    e.evaluate(1, "isLessThan", 2)
    >> true

    date = new Date()
    date2 = date.getTime() + (3600 * 24 * 1000)
    e.evaluate(date, "isLessThan", date2)
    >> true


### startsWith

    e.evaluate("baz", "startsWith", "b")
    >> true

    e.evaluate(21, "startsWith", 2)
    >> true

For arrays, startsWith checks whether the first element of the array matches to the target value.

    e.evaluate(["1", "2", "3"], "startsWith", "1")
    >> true


### contains

    e.evaluate("baz", "contains", "a")
    >> true

    e.evaluate(213, "contains", 1)
    >> true

For arrays, contains checks whether the any element of the array matches to the target value.

    e.evaluate(["1", "2", "3"], "contains", "1")
    >> true



## Evaluting Using Key Paths

Evaluations can also be performed using key paths.

    e.evaluateKeyPath("name", "is", "foo")
    >> true

    e.evaluateKeyPath("date", "isAfter", new Date())  
    >> true

    e.evaluateKeyPath("jsonDate", "isAfter", new Date())
    >> true
  

## Evaluting Using Aggregators
Aggregations can eiher use built-in aggregation functions or can extend the keypath using the 'keypath:aggregator' format.  The following aggregators are currently supported

### any

    e.any("bars.name", "is", "bar1"))
    >> true

    e.evaluateKeyPath("bars.name:any", "is", "bar1"))
    >> true


### all

    e.all("bars.name", "startsWith", "bar"))
    >> true

    e.evaluateKeyPath("bars.name:all", "startsWith", "bar"))
    >> true


### none

    e.none("bars.name", "is", "bar3"))
    >> true

    e.evaluateKeyPath("bars.name:none", "is", "bar3"))
    >> true


### sum

    e.sum("bars.number", "is", 3))
    >> true

    e.evaluateKeyPath("bars.number:sum", "is", 3))
    >> true


### min

    e.min("bars.number", "is", 1))
    >> true

    e.evaluateKeyPath("bars.number:min", "is", 1))
    >> true


### max

    e.max("bars.number", "is", 2))
    >> true

    e.evaluateKeyPath("bars.number:max", "is", 2))
    >> true


### count

    e.count("bars", "is", 2))
    >> true

    e.evaluateKeyPath("bars:count", "is", 2))
    >> true


### average

    e.average("bars.number", "is", 1.5))
    >> true

    e.evaluateKeyPath("bars.number:average", "is", 1.5))
    >> true

