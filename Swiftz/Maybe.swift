//
//  Functor.swift
//  swiftz
//
//  Created by Josh Abernathy on 6/7/2014.
//  Copyright (c) 2014 Josh Abernathy. All rights reserved.
//

/// Encapsultes a value that may or may not exist.  A Maybe<A> contains either a value of type A or
/// nothing.
///
/// Because the nil case of Maybe does not indicate any significant information about cause, it may
/// be more appropriate to use Result or Either which have explicit error cases.
public struct Maybe<A> {
	let value: A?

	var description : String {
		return "\(self.value)"
	}

	public init(_ v : A) {
		self.value = v
	}

	public init() {
		self.value = nil
	}

	/// Constructs a Maybe holding a value.
	public static func just(t : A) -> Maybe<A> {
		return Maybe(t)
	}

	/// Constructs a Maybe with no value.
	public static func none() -> Maybe {
		return Maybe()
	}

	/// Returns whether or not the receiver contains a value.
	public func isJust() -> Bool {
		switch value {
		case .Some(_): 
			return true
		case .None: 
			return false
		}
	}

	/// Returns whether or not the receiver has no value.
	public func isNone() -> Bool {
		return !isJust()
	}

	/// Forces a value from the receiver.
	///
	/// If the receiver contains no value this function will throw an exception.
	public func fromJust() -> A {
		return self.value!
	}

	/// Takes a default value and a maybe.  If the maybe is empty, the default value is returned.
	/// If the maybe contains a value, that value is returned.
	///
	/// This function is a safer form of fromJust().
	public func fromMaybe(def : A) -> A {
		if self.isNone() {
			return def
		}
		return self.fromJust()
	}

	/// Takes a default value, a function, and a maybe.  If the maybe is Nothing, the default value
	/// is returned.  If the maybe is Just, the function is applied to the value inside.
	public func maybe<B>(def : B, onVal : (A -> B)) -> B {
		if self.isNone() {
			return def
		}
		return onVal(self.fromJust())
	}
}

extension Maybe : BooleanType {
	public var boolValue : Bool {
		return isJust()
	}
}

/// MARK: Equatable

public func ==<A : Equatable>(lhs : Maybe<A>, rhs : Maybe<A>) -> Bool {
	if lhs.isNone() && rhs.isNone() {
		return true
	}
	
	if lhs.isJust() && rhs.isJust() {
		return lhs.fromJust() == rhs.fromJust()
	}
	
	return false
}

public func !=<A : Equatable>(lhs : Maybe<A>, rhs : Maybe<A>) -> Bool {
	return !(lhs == rhs)
}

/// MARK: Functor

extension Maybe : Functor {
	typealias B = Any
	typealias FB = Maybe<B>

	public func fmap<B>(f : (A -> B)) -> Maybe<B> {
		if self.isJust() {
			let b: B = f(self.fromJust())
			return Maybe<B>.just(b)
		} else {
			return Maybe<B>.none()
		}
	}
}

public func <^> <A, B>(f : A -> B, l : Maybe<A>) -> Maybe<B> {
	return l.fmap(f)
}

extension Maybe : Pointed {
	public static func pure(x : A) -> Maybe<A> {
		return Maybe.just(x)
	}
}

extension Maybe : Applicative {
	typealias FA = Maybe<A>
	typealias FAB = Maybe<A -> B>
	
	public func ap<B>(f : Maybe<A -> B>) -> Maybe<B>	{
		if f.isJust() {
			let fn: (A -> B) = f.fromJust()
			return self.fmap(fn)
		} else {
			return Maybe<B>.none()
		}
	}
}

public func <*> <A, B>(f : Maybe<(A -> B)>, l : Maybe<A>) -> Maybe<B> {
	return l.ap(f)
}

extension Maybe : Monad {
	public func bind<B>(f : A -> Maybe<B>) -> Maybe<B> {
		if self.isNone() {
			return Maybe<B>.none()
		}
		return f(self.fromJust())
	}
}


public func >>- <A, B>(l : Maybe<A>, f : A -> Maybe<B>) -> Maybe<B> {
	return l.bind(f)
}

extension Maybe : Foldable {
	public func foldr<B>(k : A -> B -> B, _ i : B) -> B {
		if self.isNone() {
			return i
		}
		return k(self.fromJust())(i)
	}

	public func foldl<B>(k : B -> A -> B, _ i : B) -> B {
		if self.isNone() {
			return i
		}
		return k(i)(self.fromJust())
	}

	public func foldMap<M : Monoid>(f : A -> M) -> M {
		return self.foldr(curry(<>) • f, M.mempty)
	}
}
