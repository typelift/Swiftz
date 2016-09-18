//
//  Arrow.swift
//  Swiftz
//
//  Created by Robert Widmann on 1/18/15.
//  Copyright (c) 2015-2016 TypeLift. All rights reserved.
//

#if !XCODE_BUILD
	import Operadics
	import Swiftx
#endif

/// An Arrow is most famous for being a "Generalization of a Monad".  They're 
/// probably better described as a more general view of computation.  Where a 
/// monad M<A> yields a value of type A given some context, an Arrow A<B, C> is 
/// a function from B -> C in some context A.  Functions are the simplest kind 
/// of Arrow (pun intended).  Their context parameter, A, is essentially empty.
/// From there, the B -> C part of the arrow gets alpha-reduced to the A -> B 
/// part of the function type.
///
/// Arrows can be modelled with circuit-esque diagrams, and indeed that can 
/// often be a better way to envision the various arrow operators.
///
/// - >>>       a -> [ f ] -> b -> [ g ] -> c
/// - <<<       a -> [ g ] -> b -> [ f ] -> c
///
/// - arr       a -> [ f ] -> b
///
/// - first     a -> [ f ]  -> b
///             c - - - - - -> c
///
/// - second    c - - - - - -> c
///             a -> [ f ]  -> b
///
///
/// - ***       a - [ f ] -> b - •
///                               \
///                                o - -> (b, d)
///                               /
///             c - [ g ] -> d - •
///
///
///                 • a - [ f ] -> b - •
///                 |                   \
/// - &&&       a - o                    o - -> (b, c)
///                 |                   /
///                 • a - [ g ] -> c - •
///
/// Arrows inherit from Category so we can get Composition For Free™.
public protocol Arrow : Category {
	/// Some arbitrary target our arrow can compose with.
	associatedtype D
	/// Some arbitrary target our arrow can compose with.
	associatedtype E

	/// Type of the result of first().
	associatedtype FIRST = K2<(A, D), (B, D)>
	/// Type of the result of second().
	associatedtype SECOND = K2<(D, A), (D, B)>

	/// Some arrow with an arbitrary target and source.  Used in split().
	associatedtype ADE = K2<D, E>
	/// Type of the result of ***.
	associatedtype SPLIT = K2<(A, D), (B, E)>

	/// Some arrow from our target to some other arbitrary target.  Used in 
	/// fanout().
	associatedtype ABD = K2<A, D>

	/// Type of the result of &&&.
	associatedtype FANOUT = K2<B, (B, D)>

	/// Lift a function to an arrow.
	static func arr(_ : (A) -> B) -> Self

	/// Splits the arrow into two tuples that model a computation that applies 
	/// our Arrow to an argument on the "left side" and sends the "right side" 
	/// through unchanged.
	///
	/// The mirror image of second().
	func first() -> FIRST

	/// Splits the arrow into two tuples that model a computation that applies 
	/// our Arrow to an argument on the "right side" and sends the "left side" 
	/// through unchanged.
	///
	/// The mirror image of first().
	func second() -> SECOND

	/// Split | Splits two computations and combines the result into one Arrow 
	/// yielding a tuple of the result of each side.
	static func ***(_ : Self, _ : ADE) -> SPLIT

	/// Fanout | Given two functions with the same source but different targets,
	/// this function splits the computation and combines the result of each 
	/// Arrow into a tuple of the result of each side.
	static func &&&(_ : Self, _ : ABD) -> FANOUT
}

/// Arrows that can produce an identity arrow.
public protocol ArrowZero : Arrow {
	/// An arrow from A -> B.  Colloquially, the "zero arrow".
	associatedtype ABC = K2<A, B>

	/// The identity arrow.
	static func zeroArrow() -> ABC
}

/// A monoid for Arrows.
public protocol ArrowPlus : ArrowZero {
	/// A binary function that combines two arrows.
	// static func <+>(_ : ABC, _ : ABC) -> ABC
}

/// Arrows that permit "choice" or selecting which side of the input to apply 
/// themselves to.
///
/// - left                     a - - [ f ] - - > b
///                            |
///             a - [f] -> b - o------EITHER------
///                            |
///                            d - - - - - - - > d
///
/// - right                    d - - - - - - - > d
///                            |
///             a - [f] -> b - o------EITHER------
///                            |
///                            a - - [ f ] - - > b
///
/// - +++       a - [ f ] -> b - •        • a - [ f ] -> b
///                               \       |
///                                o - -> o-----EITHER-----
///                               /       |
///             d - [ g ] -> e - •        • d - [ g ] -> e
///
/// - |||       a - [ f ] -> c - •        • a - [ f ] -> c •
///                               \       |                 \
///                                o - -> o-----EITHER-------o - -> c
///                               /       |                 /
///             b - [ g ] -> c - •        • b - [ g ] -> c •
///
public protocol ArrowChoice : Arrow {
	/// The result of left
	associatedtype LEFT = K2<Either<A, D>, Either<B, D>>
	/// The result of right
	associatedtype RIGHT = K2<Either<D, A>, Either<D, B>>

	/// The result of +++
	associatedtype SPLAT = K2<Either<A, D>, Either<B, E>>

	/// Some arrow from a different source and target for fanin.
	associatedtype ACD = K2<B, D>
	/// The result of |||
	associatedtype FANIN = K2<Either<A, B>, D>

	/// Feed marked inputs through the argument arrow, passing the rest through 
	/// unchanged to the output.
	func left() -> LEFT

	/// The mirror image of left.
	func right() -> RIGHT

	/// Splat | Split the input between both argument arrows, then retag and 
	/// merge their outputs into Eithers.
	static func +++(_ : Self, _ : ADE) -> SPLAT

	/// Fanin | Split the input between two argument arrows and merge their 
	/// ouputs.
	// static func |||(_ : ABD, _ : ACD) -> FANIN
}

/// Arrows that allow application of arrow inputs to other inputs.  Such arrows 
/// are equivalent to monads.
///
/// - app    (_ f : a -> b) - •
///                          \
///                           o - a - [ f ] -> b
///                          /
///          a -------> a - •
///
public protocol ArrowApply : Arrow {
	associatedtype APP = K2<(Self, A), B>
	static func app() -> APP
}

/// Arrows that admit right-tightening recursion.
///
/// The 'loop' operator expresses computations in which an output value is fed 
/// back as input, although the computation occurs only once.
///
///           •-------•
///           |       |
/// - loop    a - - [ f ] - -> b
///           |       |
///           d-------•
///
public protocol ArrowLoop : Arrow {
	associatedtype LOOP = K2<(A, D), (B, D)>

	static func loop(_ : LOOP) -> Self
}
