swiftz
======

Functional programming in Swift


SwiftZ is an effort to try to provide higher order, composable functional programming abstractions 
in the Swift programming language. These include but arent limited to: 

* Functor
* Applicative
* Monad
* Monoid
* Semigroup

Many of these are somewhat difficult to use compose/used in the Swift Language currently because
of a lack of support for Higher Kinded types as type params, Type indexed Protocols (indexed by potentially higher kinded types),
and Enums indexed by Higher Kinded types.   
