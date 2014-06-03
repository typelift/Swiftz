Swiftz
======

Swiftz is a Swift library for functional programming.

It defines purely functional data structures and functions.

**Implemented:**

- `Maybe<A>` with `Equatable`, 

**Typechecks but currently impossible:**

- List

**Note:**

The "currently impossible" data structures we believe are temporary and
the language intends to support.

**Not realised:**

These abstractions require language features that Swift does not support yet.

- Functor, Applicative, Monad, Comonad. To enable these, a higher kind,
  C++ template-template, or Scala-like kind system is needed. `radr://???`
- `enum` should derive Equatable and Comparable if possible, similar to case classes in Scala. Or a deriving mechanic
  like generics should be present. `radr://???`
