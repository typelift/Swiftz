//
//  Operators.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 28/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// MARK: Combinators

/// Compose | Applies one function to the result of another function to produce a third function.
///
///     f : B -> C
///     g : A -> B
///     (f • g)(x) === f(g(x)) : A -> B -> C
infix operator • {
	associativity right
}

/// Apply | Applies an argument to a function.
infix operator § {
	associativity right
	precedence 0
}

/// Pipe Backward | Applies the function to its left to an argument on its right.
infix operator <| {
	associativity right
	precedence 0
}

/// Pipe forward | Applies an argument on the left to a function on the right.
infix operator |> {
	associativity left
	precedence 0
}

/// MARK: Control.*

/// Fmap | Maps a function "inside" a functor.
infix operator <^> {
	associativity left
}

/// Ap | Applies a function "inside" a functor to another functor.
infix operator <*> {
	associativity left
}

/// Bind | Sequences and composes two monadic actions by passing the value inside the monad on the 
/// left to a function on the right yielding a new monad.
infix operator >>- {
	associativity left
}

/// MARK: Data.Result

/// From | Creates a Result given a function that can possibly fail with an error.
infix operator !! {
	associativity none
}
