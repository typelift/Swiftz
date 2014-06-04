Swiftz
======

Swiftz is a Swift library for functional programming.

It defines purely functional data structures and functions.

Examples
--------

```swift
let xs = [1, 2, 0, 3, 4]

// we can use the Min semigroup to find the minimal element in xs
sconcat(Min(), 2, xs) // 0

// we can use the Sum monoid to find the sum of xs
mconcat(Sum<Int8, NInt8>(i: { return nint8 }), xs) // 10

// we can delay computations with futures
let x: Future<Int> = Future(exec: gcdExecutionContext, {
  sleep(1)
  return 4
})
x.result() == x.result() // true, returns in 1 second

// we can map and flatMap over futures
x.map({ $0.description }).result() // "4", returns instantly
x.flatMap({ (x: Int) -> Future<Int> in
  return Future(exec: gcdExecutionContext, { sleep(1); return x + 1 })
}).result() // sleeps another second, then returns 5
```

Implementation
--------------

**Implemented:**

- `Control/Base` functions
- `Future<A>`
- `Semigroup<A>` and `Monoid<A>` with some instances
- `Num` signature and functors
- `flatMap` for `Optional<A>`

**Typechecks but currently impossible:**

- `Either<A, B>` with `Equatable`
- `List<A>`

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
