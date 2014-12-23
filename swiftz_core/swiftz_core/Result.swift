//
//  Result.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import class Foundation.NSError
import typealias Foundation.NSErrorPointer

/// Result is similar to an Either, except specialized to have an Error case that can
/// only contain an NSError.
public enum Result<V> {
	case Error(NSError)
	case Value(Box<V>)
	
	public init(_ e: NSError?, _ v: V) {
		if let ex = e {
			self = Result.Error(ex)
		} else {
			self = Result.Value(Box(v))
		}
	}
	
	/// Converts a Result to a more general Either type.
	public func toEither() -> Either<NSError, V> {
		switch self {
		case let Error(e): 
			return .Left(Box(e))
		case let Value(v): 
			return Either.Right(Box(v.value))
		}
	}
	
	/// Much like the ?? operator for Optional types, takes a value and a function,
	/// and if the Result is Error, returns the error, otherwise maps the function over
	/// the value in Value and returns that value.
	public func fold<B>(value: B, f: V -> B) -> B {
		switch self {
		case Error(_): 
			return value
		case let Value(v): 
			return f(v.value)
		}
	}
	
	/// Named function for `>>-`. If the Result is Error, simply returns
	/// a New Error with the value of the receiver. If Value, applies the function `f`
	/// and returns the result.
	public func flatMap<S>(f: V -> Result<S>) -> Result<S> {
		return self >>- f
	}
	
	/// Creates an Error with the given value.
	public static func error(e: NSError) -> Result<V> {
		return .Error(e)
	}
	
	/// Creates a Value with the given value.
	public static func value(v: V) -> Result<V> {
		return .Value(Box(v))
	}
}

/// MARK: Function Constructors

/// Takes a function that can potentially raise an error and constructs a Result depending on
/// whether the error pointer has been set.
public func from<A>(fn : (NSErrorPointer) -> A) -> Result<A> {
	var err : NSError? = nil
	let b = fn(&err)
	return (err != nil) ? .Error(err!) : .Value(Box(b))
}

/// Takes a 1-ary function that can potentially raise an error and constructs a Result depending on
/// whether the error pointer has been set.
public func from<A, B>(fn : (A, NSErrorPointer) -> B) -> A -> Result<B> {
	return { a in 
		var err : NSError? = nil
		let b = fn(a, &err)
		return (err != nil) ? .Error(err!) : .Value(Box(b))
	}
}

/// Takes a 2-ary function that can potentially raise an error and constructs a Result depending on
/// whether the error pointer has been set.
public func from<A, B, C>(fn : (A, B, NSErrorPointer) -> C) -> A -> B -> Result<C> {
	return { a in { b in
		var err : NSError? = nil
		let c = fn(a, b, &err)
		return (err != nil) ? .Error(err!) : .Value(Box(c))
	} }
}

/// Takes a 3-ary function that can potentially raise an error and constructs a Result depending on
/// whether the error pointer has been set.
public func from<A, B, C, D>(fn : (A, B, C, NSErrorPointer) -> D) -> A -> B -> C -> Result<D> {
	return { a in { b in { c in
		var err : NSError? = nil
		let d = fn(a, b, c, &err)
		return (err != nil) ? .Error(err!) : .Value(Box(d))
	} } }
}

/// Takes a 4-ary function that can potentially raise an error and constructs a Result depending on
/// whether the error pointer has been set.
public func from<A, B, C, D, E>(fn : (A, B, C, D, NSErrorPointer) -> E) -> A -> B -> C -> D -> Result<E> {
	return { a in { b in { c in { d in
		var err : NSError? = nil
		let e = fn(a, b, c, d, &err)
		return (err != nil) ? .Error(err!) : .Value(Box(e))
	} } } }
}

/// Takes a 5-ary function that can potentially raise an error and constructs a Result depending on
/// whether the error pointer has been set.
public func from<A, B, C, D, E, F>(fn : (A, B, C, D, E, NSErrorPointer) -> F) -> A -> B -> C -> D -> E -> Result<F> {
	return { a in { b in { c in { d in { e in
		var err : NSError? = nil
		let f = fn(a, b, c, d, e, &err)
		return (err != nil) ? .Error(err!) : .Value(Box(f))
	} } } } }
}

/// Infix 1-ary from
public func !!<A, B>(fn : (A, NSErrorPointer) -> B, a : A) -> Result<B> {
	var err : NSError? = nil
	let b = fn(a, &err)
	return (err != nil) ? .Error(err!) : .Value(Box(b))
}

/// Infix 2-ary from
public func !!<A, B, C>(fn : (A, B, NSErrorPointer) -> C, t : (A, B)) -> Result<C> {
	var err : NSError? = nil
	let c = fn(t.0, t.1, &err)
	return (err != nil) ? .Error(err!) : .Value(Box(c))
}

/// Infix 3-ary from
public func !!<A, B, C, D>(fn : (A, B, C, NSErrorPointer) -> D, t : (A, B, C)) -> Result<D> {
	var err : NSError? = nil
	let d = fn(t.0, t.1, t.2, &err)
	return (err != nil) ? .Error(err!) : .Value(Box(d))
}

/// Infix 4-ary from
public func !!<A, B, C, D, E>(fn : (A, B, C, D, NSErrorPointer) -> E, t : (A, B, C, D)) -> Result<E> {
	var err : NSError? = nil
	let e = fn(t.0, t.1, t.2, t.3, &err)
	return (err != nil) ? .Error(err!) : .Value(Box(e))
}

/// Infix 5-ary from
public func !!<A, B, C, D, E, F>(fn : (A, B, C, D, E, NSErrorPointer) -> F, t : (A, B, C, D, E)) -> Result<F> {
	var err : NSError? = nil
	let f = fn(t.0, t.1, t.2, t.3, t.4, &err)
	return (err != nil) ? .Error(err!) : .Value(Box(f))
}

/// MARK: Equatable

public func ==<V: Equatable>(lhs: Result<V>, rhs: Result<V>) -> Bool {
	switch (lhs, rhs) {
	case let (.Error(l), .Error(r)) where l == r: 
		return true
	case let (.Value(l), .Value(r)) where l.value == r.value: 
		return true
	default: 
		return false
	}
}

public func !=<V: Equatable>(lhs: Result<V>, rhs: Result<V>) -> Bool {
	return !(lhs == rhs)
}

/// MARK: Functor, Applicative, Monad

/// Applicative `pure` function, lifts a value into a Value.
public func pure<V>(a: V) -> Result<V> {
	return .Value(Box(a))
}

/// Functor `fmap`. If the Result is Error, ignores the function and returns the Error.
/// If the Result is Value, applies the function to the Right value and returns the result
/// in a new Value.
public func <^><VA, VB>(f: VA -> VB, a: Result<VA>) -> Result<VB> {
	switch a {
	case let .Error(l): 
		return .Error(l)
	case let .Value(r): 
		return Result.Value(Box(f(r.value)))
	}
}

/// Applicative Functor `apply`. Given an Result<VA -> VB> and an Result<VA>,
/// returns a Result<VB>. If the `f` or `a' param is an Error, simply returns an Error with the
/// same value. Otherwise the function taken from Value(f) is applied to the value from Value(a)
/// And a Value is returned.
public func <*><VA, VB>(f: Result<VA -> VB>, a: Result<VA>) -> Result<VB> {
	switch (a, f) {
	case let (.Error(l), _): 
		return .Error(l)
	case let (.Value(r), .Error(m)): 
		return .Error(m)
	case let (.Value(r), .Value(g)): 
		return Result<VB>.Value(Box(g.value(r.value)))
	}
}

/// Monadic `bind`. Given an Result<VA>, and a function from VA -> Result<VB>,
/// applies the function `f` if `a` is Value, otherwise the function is ignored and an Error
/// with the Error value from `a` is returned.
public func >>-<VA, VB>(a: Result<VA>, f: VA -> Result<VB>) -> Result<VB> {
	switch a {
	case let .Error(l): 
		return .Error(l)
	case let .Value(r): 
		return f(r.value)
	}
}
