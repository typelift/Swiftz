[![Build Status](https://travis-ci.org/typelift/swiftz.svg)](https://travis-ci.org/typelift/swiftz)

Swiftz
======

Swiftz is a Swift library for functional programming.

It defines functional data structures, functions, idioms, and extensions that augment 
the Swift standard library.

For a small, simpler way to introduce functional primitives into any codebase,
see [Swiftx](https://github.com/typelift/Swiftx). 

Setup
-----

To add Swiftz to your application:

**Using Carthage**

- Add Swiftz to your Cartfile
- Run `carthage update`
- Drag the relevant copy of Swiftz into your project.
- Expand the Link Binary With Libraries phase
- Click the + and add Swiftz
- Click the + at the top left corner to add a Copy Files build phase
- Set the directory to `Frameworks`
- Click the + and add Swiftz

**Using Git Submodules**

- Clone Swiftz as a submodule into the directory of your choice
- Run `git submodule init -i --recursive`
- Drag `Swiftz.xcodeproj` or `Swiftz-iOS.xcodeproj` into your project tree as a subproject
- Under your project's Build Phases, expand Target Dependencies
- Click the + and add Swiftz
- Expand the Link Binary With Libraries phase
- Click the + and add Swiftz
- Click the + at the top left corner to add a Copy Files build phase
- Set the directory to `Frameworks`
- Click the + and add Swiftz

Introduction
------------

Swiftz draws inspiration from a number of functional libraries 
and languages.  Chief among them are [Scalaz](https://github.com/scalaz/scalaz),
[Prelude/Base](https://hackage.haskell.org/package/base), [SML
Basis](http://sml-family.org/Basis/), and the [OCaml Standard
Library](http://caml.inria.fr/pub/docs/manual-ocaml/stdlib.html).  Elements of
the library rely on their combinatorial semantics to allow declarative ideas to
be expressed more clearly in Swift.

Swiftz is a proper superset of [Swiftx](https://github.com/typelift/Swiftx) that
implements higher-level data types like Lenses, Zippers, HLists, and a number of
typeclasses integral to programming with the maximum amount of support from the
type system.  A small number of examples are included in the test suite to
illustrate uses of these kinds of abstractions.

Operators
---------

Swiftz introduces the following operators at global scope

Operator | Name      | Type
-------- | --------- | ------------------------------------------
`•`      | compose   | `• <A, B, C>(f: B -> C, g: A -> B) -> A -> C`
`<|`     | apply     | `<| <A, B>(A -> B, A) -> B`
`|>`     | thrush    | `|> <A, B>(A, A -> B) -> B`
`<-`     | extract   | `<- <A>(M<A>, A) -> Void`
`∪`      | union     | `∪ <A>(Set<A>, Set<A>) -> Set<A>`
`∩`      | intersect | `∩ <A>(Set<A>, Set<A>) -> Set<A>`
`<^>`    | fmap      | `<^> <A, B>(A -> B, a: F<A>) -> F<B>`
`<^^>`   | imap      | `<^^> <I, J, A>(I -> J, F<I, A>) -> F<J, A>`
`<!>`    | contramap | `<^> <I, J, A>(J -> I, F<I, A>) -> F<J, A>`
`<*>`    | apply     | `<*> <A, B>(F<A -> B>, F<A>) -> F<B>`
`>>-`    | bind      | `>>- <A, B>(F<A>, A -> F<B>) -> F<B>`
`->>`    | extend    | `->> <A, B>(F<A>, F<A> -> B) -> F<B>`

System Requirements
===================

Swiftz and Swiftz Core support OS X 10.9+ and iOS 7.0+.

License
=======

Swiftz and Swiftz Core are released under the BSD license.

