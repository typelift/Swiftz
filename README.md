[![Build Status](https://travis-ci.org/typelift/swiftz.svg)](https://travis-ci.org/typelift/swiftz)

Swiftz
======

Swiftz is a Swift library for functional programming.

It defines purely functional data structure, functions, and extensions that augment the Swift standard library.

Setup
-----

Swiftz comes in two distinct flavors: Core and Full.  Swiftz_Core is
a smaller and simpler way to introduce pure functional datatypes into any
codebase.  It also provides a few of the more popular typeclasses and conformances
for Swiftz types.  It can be included one of two ways:

**Framework**

- Drag `swiftz_core.xcodeproj` into your project tree as a subproject
- Under your project's Build Phases, expand Target Dependencies
- Click the + and add swiftz_core
- Expand the Link Binary With Libraries phase
- Click the + and add swiftz_core
- Click the + at the top left corner to add a Copy Files build phase
- Set the directory to `Frameworks`
- Click the + and add swiftz_core

**Standalone**

- Copy the swift files under `swiftz/swiftz_core/swiftz_core` into your
  project.

Using the full Swiftz framework works in much the same way:

- Drag `swiftz.xcodeproj` into your project tree as a subproject
- Under your project's Build Phases, expand Target Dependencies 
- Click the + and add swiftz
- Expand the Link Binary With Libraries phase
- Click the + and add swiftz
- Click the + at the top left corner to add a Copy Files build phase
- Set the directory to `Frameworks`
- Click the + and add swiftz *and* swiftz_core

Examples
--------

**Data abstractions:**

```swift
let xs: [Int8] = [1, 2, 0, 3, 4]

// we can use the Min semigroup to find the minimal element in xs
sconcat(Min(), 2, xs) // 0

// we can use the Sum monoid to find the sum of xs
mconcat(Sum<Int8, NInt8>(i: { return nint8 }), xs) // 10
```

**Either and Result:**

```swift
// Result represents something that could work or be an NSError.
// Say we have 2 functions, the first fetches from a web services,
// the second decodes the string into a User.
// Both *could* fail with an NSError, so we use a Result<A>.
func getWeb() -> Result<String> {
  var e: NSError?
  let str = doStuff("foo", e)
  return Result(e, str)
}

func decodeWeb(str: String) -> Result<User> {
  var e: NSError?
  let user = decode(str, e)
  return Result(e, user)
}

// We can compose these two functions with the `>>-` function.

let getUser: Result<User> = getWeb() >>- decodeWeb

switch (getUser) {
case let .Error(e): 
	println("NSError: \(e)")
case let .Value(user): 
	println(user.name)
}

// If we use getUser and getWeb fails, the NSError will be from doStuff.
// If decodeWeb fails, then it will be an NSError from decode.
// If both steps work, then it will be a User!
```

**JSON:**

```swift
let js: NSData = ("[1,\"foo\"]").dataUsingEncoding(NSUTF8StringEncoding,
                  allowLossyConversion: false)
let lhs: JSValue = JSValue.decode(js)
let rhs: JSValue = .JSArray([.JSNumber(1), .JSString("foo")])
XCTAssert(lhs == rhs)
XCTAssert(rhs.encode() == js)

// The User class blob/fc9fead44/swiftzTests/swiftzTests.swift#L14-L48
// implements JSONDecode, so we can decode JSON into it and get a `User?`
let userjs: NSData = ("{\"name\": \"max\", \"age\": 10, \"tweets\":
                       [\"hello\"], \"attrs\": {\"one\": \"1\"}}")
  .dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
let user: User? = JSValue.decode(userjs) >>- User.fromJSON
XCTAssert(user! == User("max", 10, ["hello"], ["one": "1"]))
```

**Concurrency:**

```swift
// we can delay computations with futures
let x: Future<Int> = Future(exec: gcdExecutionContext, {
	sleep(1)
	return 4
})
x.result() == x.result() // true, returns in 1 second

// Channels
let chan: Chan<Int> = Chan()
chan.write(1)
chan.write(2) // this could happen asynchronously
let x1 = chan.read()
let x2 = chan.read()
println((x1, x2)) // 1, 2

// we can map and flatMap over futures
x.map({ $0.description }).result() // "4", returns instantly
x.flatMap({ (x: Int) -> Future<Int> in
	return Future(exec: gcdExecutionContext, { sleep(1); return x + 1 })
}).result() // sleeps another second, then returns 5
```

Swiftz Core
-----------

Swiftz Core only contains interfaces to concepts and implementations
for data abstractions from the standard library.

Operators
---------

Swiftz introduces the following operators at global scope

Operator | Name      | Type
-------- | --------- | ------------------------------------------
`•`      | compose   | `•<A, B, C>(f: B -> C, g: A -> B) -> A -> C`
`<|`     | apply     | `<|<A, B>(A -> B, A) -> B`
`|>`     | thrush    | `|><A, B>(A, A -> B) -> B`
`<-`     | extract   | `<-<A>(M<A>, A) -> Void`
`∪`      | union     | `∪<A>(Set<A>, Set<A>) -> Set<A>`
`∩`      | intersect | `∩<A>(Set<A>, Set<A>) -> Set<A>`
`<^>`    | fmap      | `<^><A, B>(A -> B, a: F<A>) -> F<B>`
`<^^>`   | imap      | `<^^><I, J, A>(I -> J, F<I, A>) -> F<J, A>`
`<!>`    | contramap | `<^><I, J, A>(J -> I, F<I, A>) -> F<J, A>`
`<*>`    | apply     | `<*><A, B>(F<A -> B>, F<A>) -> F<B>`
`>>-`    | bind      | `>>-<A, B>(F<A>, A -> F<B>) -> F<B>`
`->>`    | extend    | `->><A, B>(F<A>, F<A> -> B) -> F<B>`

