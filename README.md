[![Build Status](https://travis-ci.org/typelift/swiftz.svg)](https://travis-ci.org/typelift/swiftz)

Swiftz
======

Swiftz is a Swift library for functional programming.

It defines purely functional data structures and functions.

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

Operator | Name      | Type
-------- | --------- | ------------------------------------------
`pure`   | pure      | `pure<A>(a: A) -> F<A>`
`<^>`    | fmap      | `<^><A, B>(f: A -> B, a: F<A>) -> F<B>`
`<^^>`   | imap      | `<^^><I, J, A>(f: I -> J, f: F<I, A>) -> F<J, A>`
`<!>`    | contramap | `<^><I, J, A>(f: J -> I, f: F<I, A>) -> F<J, A>`
`<*>`    | apply     | `<*><A, B>(f: F<A -> B>, a: F<A>) -> F<B>`
`>>-`    | bind      | `>>-<A, B>(a: F<A>, f: A -> F<B>) -> F<B>`
`->>`    | extend    | `->><A, B>(a: F<A>, f: F<A> -> B) -> F<B>`

Types with instances of these operators:

- `Optional`
- `Array` (non-determinism, cross product)
- `Either` (right bias)
- `Result`
- `ImArray`
- `Set` (except `<*>`)

*Note: these functions are not in any protocol. They are in global scope.*

Adding Swiftz to a Project
--------------------------

1. Build the `.framework`
2. Copy it to your project
3. Add a build phase to copy frameworks, and add that swiftz to the list
4. Add `--deep` to "Other Code Signing Flags"
5. Check `Versions/A/Frameworks/` doesn't contain the Swift runtime (it will
    be duplicated with the App's copy of the runtime, causing a 4mb increase
    in file size)

Implementation
--------------

**Implemented:**

- `Future<A>`, `MVar<A>` and `Chan<A>` concurrency abstractions
- `JSON` types and encode / decode protocols
- Lenses
- `Semigroup<A>` and `Monoid<A>` with some instances
- `Num` protocol
- `Either<L, R>` and `Result<V>`
- `maybe` for `Optional<A>`,
- `Dictionary` and `Array` extensions
- Immutable `Set<A: Hashable>` and `ImArray<A>`
