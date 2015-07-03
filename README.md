[![Build Status](https://travis-ci.org/typelift/Swiftz.svg)](https://travis-ci.org/typelift/Swiftz)

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
implements higher-level data types like Arrows, Lists, HLists, and a number of
typeclasses integral to programming with the maximum amount of support from the
type system.

To illustrate use of these abstractions, take these few examples:

**Lists**

```swift
import struct Swiftz.List

//: Cycles a finite list of numbers into an infinite list.
let finite : List<UInt> = [1, 2, 3, 4, 5]
let infiniteCycle = finite.cycle()

//: Lists also support the standard map, filter, and reduce operators.
let l : List<Int> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

let twoToEleven = l.map(+1) // [2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
let even = l.filter((==0) • (%2)) // [2, 4, 6, 8, 10]
let sum = l.reduce(curry(+), initial: 0) // 55

//: Plus a few more.
let partialSums = l.scanl(curry(+), initial: 0) // [0, 1, 3, 6, 10, 15, 21, 28, 36, 45, 55]
let firstHalf = l.take(5) // [1, 2, 3, 4, 5]
let lastHalf = l.drop(5) // [6, 7, 8, 9, 10]
```

**JSON**

```swift
import protocol Swiftz.JSONDecode
import struct Swiftz.JSONKeypath
    
public class User : JSONDecodable {
    typealias J = User
    let name : String
    let age : Int
    let tweets : [String]
    let attr : String
    
    public init(_ n : String, _ a : Int, _ t : [String], _ r : String) {
        name = n
        age = a
        tweets = t
        attr = r
    }
    
    // JSON
    public class func create(x : String) -> Int -> ([String] -> String -> User) {
        return { y in { z in { User(x, y, z, $0) } } }
    }
    
    public class func fromJSON(x : JSONValue) -> User? {
        return User.create
			<^> x <? "name" 
			<*> x <? "age"
			<*> x <? "tweets" 
			<*> x <? "attrs" <> "one" // A nested keypath
    }
}

public func ==(lhs : User, rhs : User) -> Bool {
    return lhs.name == rhs.name && lhs.age == rhs.age && lhs.tweets == rhs.tweets && lhs.attr == rhs.attr
}

let userjs = "{\"name\": \"max\", \"age\": 10, \"tweets\": [\"hello\"], \"attrs\": {\"one\": \"1\"}}"

//: The JSON we've decoded works perfectly with the User structure we defined above.  In case it didn't,
//: the user would be nil.
let user : User? = JSONValue.decode(userjs) >>- User.fromJSON // .Some( User("max", 10, ["hello"], "1") )
```
 
**Semigroups and Monoids**

```swift
let xs = [1, 2, 0, 3, 4]

import protocol Swiftz.Semigroup
import func Swiftz.sconcat
import struct Swiftz.Min

//: The least element of a list can be had with the Min Semigroup.
let smallestElement = sconcat(Min(2), xs.map { Min($0) }).value() // 0

import protocol Swiftz.Monoid
import func Swiftz.mconcat
import struct Swiftz.Sum

//: Or the sum of a list with the Sum Monoid.
let sum = mconcat(xs.map { Sum($0) }).value() // 10

import struct Swiftz.Product

//: Or the product of a list with the Product Monoid.
let product = mconcat(xs.map { Product($0) }).value() // 0
```

**Arrows**

```swift
import struct Swiftz.Function
import struct Swiftz.Either

//: An Arrow is a function just like any other.  Only this time around we
//: can treat them like a full algebraic structure and introduce a number
//: of operators to augment them.
let comp = Function.arr(+3) • Function.arr(*6) • Function.arr(/2)
let both = comp.apply(10) // 33

//: An Arrow that runs both operations on its input and combines both
//: results into a tuple.
let add5AndMultiply2 = Function.arr(+5) &&& Function.arr(*2)
let both = add5AndMultiply2.apply(10) // (15, 20)

//: Produces an Arrow that chooses a particular function to apply
//: when presented with the side of an Either.
let divideLeftMultiplyRight = Function.arr(/2) ||| Function.arr(*2)
let left = divideLeftMultiplyRight.apply(Either.left(4)) // 2
let right = divideLeftMultiplyRight.apply(Either.right(7)) // 14
```

Operators
---------

Swiftz introduces the following operators at global scope

Operator | Name           | Type
-------- | -------------- | ------------------------------------------
`•`      | compose        | `•    <A, B, C>(B -> C, A -> B) -> A -> C`
`<|`     | apply          | `<|   <A, B>(A -> B, A) -> B`
`|>`     | thrush         | `|>   <A, B>(A, A -> B) -> B`
`<-`     | extract        | `<-   <A>(M<A>, A) -> Void`
`∪`      | union          | `∪    <A>(Set<A>, Set<A>) -> Set<A>`
`∩`      | intersect      | `∩    <A>(Set<A>, Set<A>) -> Set<A>`
`!!`     | from           | `!!   <A, ..., F>(NSErrorPointer, A, ..., F) -> Result<F>`
`<>`     | op             | `<>   <A : Monoid>(A, A) -> A`
`<?`     | retrieve       | `<?   <A : JSONDecodable>(JSONValue, JSONKeypath) -> A?` 
`<!`     | force retrieve | `<!   <A : JSONDecodable>(JSONValue, JSONKeypath) -> A` 
`<^>`    | fmap           | `<^>  <A, B>(A -> B, a: F<A>) -> F<B>`
`<^^>`   | imap           | `<^^> <I, J, A>(I -> J, F<I, A>) -> F<J, A>`
`<!>`    | contramap      | `<^>  <I, J, A>(J -> I, F<I, A>) -> F<J, A>`
`<*>`    | apply          | `<*>  <A, B>(F<A -> B>, F<A>) -> F<B>`
`>>-`    | bind           | `>>-  <A, B>(F<A>, A -> F<B>) -> F<B>`
`->>`    | extend         | `->>  <A, B>(F<A>, F<A> -> B) -> F<B>`
`<<<`    | r-t-l compose  | `<<<  <C, A, B, C>(C<B, C>, C<A, B>) -> C<A, C>` 
`>>>`    | l-t-r compose  | `>>>  <C, A, B, C>(C<A, B>, C<B, C>) -> C<A, C>` 
`&&&`    | split          | `&&&  <A, B, C, D>(A<B, C>, A<B, D>) -> A<B, (C, D)>` 
`***`    | fanout         | `***  <A, B, C, D, E>(A<B, C>, A<D, E>) -> A<(B, D), (C, E)>` 
`+++`    | splat          | `+++  <A, B, C, D, E>(A<B, C>, A<D, E>) -> A<Either<D, B>, Either<C, E>>`
`|||`    | fanin          | `|||  <A, B, C, D, E>(A<B, D>, A<C, D>) -> A<Either<B, C>, D>`
`<+>`    | op             | `<+>  <A, B, C>(A<B, C>, A<B, C>) -> A<B, C>`
 

System Requirements
===================

Swiftz supports OS X 10.9+ and iOS 7.0+.

License
=======

Swiftz is released under the BSD license.

