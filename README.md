Swiftz
======

Swiftz is a Swift library for functional programming.

It defines purely functional data structures and functions.

Examples
--------

**Data abstractions:**

```swift
let xs = [1, 2, 0, 3, 4]

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

// We can compose these two functions with the `>>=` function.

let getUser: Result<User> = getWeb() >>= decodeWeb

switch (getUser) {
  case let .Error(e): println("NSError: \(e)")
  case let .Value(user): println(user.name)
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
let user: User? = JSValue.decode(userjs) >>= User.fromJSON
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

Operators
---------

Operator | Name  | Type
-------- | ----- | ------------------------------------------
`pure`   | pure  | `pure<A>(a: A) -> F<A>`
`<^>`    | fmap  | `<^><A, B>(f: A -> B, a: F<A>) -> F<B>`
`<*>`    | apply | `<*><A, B>(f: F<A -> B>, a: F<A>) -> F<B>`
`>>=`    | bind  | `>>=<A, B>(a: F<A>, f: A -> F<B>) -> F<B>`

Types with instances of these operators:

- Optional
- Array (non-determinism, cross product)
- Either (right bias)

*Note: these functions are not in any protocol. They are in global scope.*

Implementation
--------------

**Implemented:**

- `Future<A>`, `MVar<A>` and `Chan<A>` concurrency abstractions
- `JSON` types and encode / decode protocols
- `Semigroup<A>` and `Monoid<A>` with some instances
- `Num` protocol
- `Either<L, R>` and `Result<V>`
- `maybe` for `Optional<A>`, 
- `Dictionary` and `Array` extensions

**Note:**

The "currently impossible" data structures we think the language intends to support.

**Not realised:**

These abstractions require language features that Swift does not support yet.

- `Either<A, B>` crashes with `unimplemented IRGen feature! non-fixed multi-payload enum layout`. `rdar://17109392`
- `List<A>` by an enum crashes the compiler. `rdar://???`
- `List<A>` via a super class and 2 sub classes crashes with `unimplemented IRGen feature! non-fixed class layout`. `rdar://17109323`
- Functor, Applicative, Monad, Comonad. To enable these, a higher kind,
  C++ template-template, or Scala-like kind system is needed. `rdar://???`

**General notes:**

- `enum` should derive Equatable and Comparable if possible, similar to case classes in Scala. Or a deriving mechanic
  like generics should be present. `rdar://???`
