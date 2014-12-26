//
//  Either.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import class Foundation.NSError

/// The Either type represents values with two possibilities: a value of type Either<A, B> is either
/// Left<A> or Right<B>.
///
/// The Either type is sometimes used to represent a value which is either correct or an error; by 
/// convention, the Left constructor is used to hold an error value and the Right constructor is 
/// used to hold a correct value (mnemonic: "right" also means "correct").
public enum Either<L, R> {
	case Left(Box<L>)
	case Right(Box<R>)
	
	/// Converts a Either to a Result, which is a more specialized type that
	/// contains an NSError or a value.
	public func toResult(ev: L -> NSError) -> Result<R> {
		return either({ e in Result.Error(ev(e)) }, { v in .Value(Box(v)) });
	}
	
	
	/// Much like the ?? operator for Optional types, takes a value and a function,
	/// and if the Either is Left, returns the value, otherwise maps the function over
	/// the value in Right and returns that value.
	public func fold<B>(value: B, f: R -> B) -> B {
		return either({ _ in value }, { r in f(r) });
	}
	
	/// Named function for `>>-`. If the Either is Left, simply returns
	/// a New Left with the value of the receiver. If Right, applies the function `f`
	/// and returns the result.
	public func flatMap<S>(f: R -> Either<L, S>) -> Either<L, S> {
		return self >>- f
	}
	
	/// Creates a Left with the given value.
	public static func left(l: L) -> Either<L, R> {
		return .Left(Box(l))
	}
	
	/// Creates a Right with the given value.
	public static func right(r: R) -> Either<L, R> {
		return .Right(Box(r))
	}
	
	/// Case analysis for the Either type. If the value is Left(a), apply the first function to a;
	/// if it is Right(b), apply the second function to b.
	public func either<A>(onL: L -> A, onR: R -> A) -> A {
		switch self {
		case let Left(e): 
			return onL(e.value)
		case let Right(e): 
			return onR(e.value)
		}
	}
}

/// Applicative `pure` function, lifts a value into an Right.
public func pure<L, R>(a: R) -> Either<L, R> {
	return .Right(Box(a))
}

/// Fmap | If the Either is Left, ignores the function and returns the Left. If the Either is Right,
/// applies the function to the Right value and returns the result in a new Right.
public func <^><L, RA, RB>(f: RA -> RB, a: Either<L, RA>) -> Either<L, RB> {
	switch a {
	case let .Left(l): 
		return .Left(l)
	case let .Right(r): 
		return Either<L, RB>.Right(Box(f(r.value)))
	}
}

/// Ap | Given an Either<L, RA -> RB> and an Either<L,RA>, returns an Either<L,RB>. If the `f` or 
/// `a' param is a Left, simply returns a Left with the same value. Otherwise the function taken 
/// from Right(f) is applied to the value from Right(a) and a Right is returned.
public func <*><L, RA, RB>(f: Either<L, RA -> RB>, a: Either<L, RA>) -> Either<L, RB> {
	switch (a, f) {
	case let (.Left(l), _): 
		return .Left(l)
	case let (.Right(r), .Left(m)):
		return .Left(m)
	case let (.Right(r), .Right(g)):
		return Either<L, RB>.Right(Box(g.value(r.value)))
	}
}

/// Bind | Given an Either<L,RA>, and a function from RA -> Either<L,RB>, applies the function `f` 
/// if `a` is Right, otherwise the function is ignored and a Left with the Left value from `a` is 
/// returned.
public func >>-<L, RA, RB>(a: Either<L, RA>, f: RA -> Either<L, RB>) -> Either<L, RB> {
	switch a {
	case let .Left(l): 
		return .Left(l)
	case let .Right(r): 
		return f(r.value)
	}
}

/// MARK: Equatable
public func ==<L: Equatable, R: Equatable>(lhs: Either<L, R>, rhs: Either<L, R>) -> Bool {
	switch (lhs, rhs) {
	case let (.Left(l), .Left(r)) where l.value == r.value:
		return true
	case let (.Right(l), .Right(r)) where l.value == r.value:
		return true
	default:
		return false
	}
}

public func !=<L: Equatable, R: Equatable>(lhs: Either<L, R>, rhs: Either<L, R>) -> Bool {
	return !(lhs == rhs)
}
