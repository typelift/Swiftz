//
//  OptionalExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 4/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

extension Optional {
	/// Case analysis for the Optional type.  Given a maybe, a default value in case it is None, and
	/// a function, maps the function over the value in the Maybe.
	public func maybe<B>(def : B, onSome : T -> B) -> B {
		switch self {
		case .None:
			return def
		case let .Some(x):
			return onSome(x)
		}
	}


	/// Given an Optional and a default value returns the value of the Optional when it is Some, else
	/// this function returns the default value.
	public func getOrElse(def : T) -> T {
		switch self {
		case .None:
			return def
		case let .Some(x):
			return x
		}
	}
}

/// MARK: Instances

extension Optional : Functor {
	typealias A = T
	typealias B = Any
	typealias FB = Optional<B>

	public func fmap<B>(f : T -> B) -> Optional<B> {
		return self.map(f)
	}
}

public func <^> <A, B>(f : A -> B, l : Optional<A>) -> Optional<B> {
	return l.fmap(f)
}

extension Optional : Pointed {
	public static func pure(x : T) -> Optional<T> {
		return .Some(x)
	}
}

extension Optional : Applicative {
	typealias FA = Optional<A>
	typealias FAB = Optional<A -> B>

	public func ap<B>(f : Optional<A -> B>) -> Optional<B>	{
		if let fn = f {
			return self.fmap(fn)
		}
		return .None
	}
}

public func <*> <A, B>(f : Optional<(A -> B)>, l : Optional<A>) -> Optional<B> {
	return l.ap(f)
}

extension Optional : Monad {
	public func bind<B>(f : A -> Optional<B>) -> Optional<B> {
		return self.flatMap(f)
	}
}

public func >>- <A, B>(l : Optional<A>, f : A -> Optional<B>) -> Optional<B> {
	return l.bind(f)
}

extension Optional : Foldable {
	public func foldr<B>(k : A -> B -> B, _ i : B) -> B {
		if let v = self {
			return k(v)(i)
		}
		return i
	}

	public func foldl<B>(k : B -> A -> B, _ i : B) -> B {
		if let v = self {
			return k(i)(v)
		}
		return i
	}

	public func foldMap<M : Monoid>(f : A -> M) -> M {
		return self.foldr(curry(<>) • f, M.mempty)
	}
}


/// Forbidden by Swift 1.2; see ~( http://stackoverflow.com/a/29750368/945847 ))
/// Given one or more Optional values, returns the first Optional value that is not nil
/// when evaulated from left to right
// public func coalesce<T>(all : @autoclosure () -> T? ...) -> T? {
// 	for f : () -> T? in all {
// 		if let x = f() { return x }
// 	}
// 	return nil
// }

/// Forbidden by Swift 1.2; see ~( http://stackoverflow.com/a/29750368/945847 ))
/// Given one or more Optional values, returns the first Optional value that is not nil
/// and satisfies the approve function when evaulated from left to right
// public func coalesce<T>(approve : T -> Bool) -> (@autoclosure () -> T? ...) -> T? {
// 	return { all in
// 		for f : () -> T? in all {
// 			if let x = f() {
// 				if approve(x) { return x }
// 			}
// 		}
// 		return nil
// 	}
// }
