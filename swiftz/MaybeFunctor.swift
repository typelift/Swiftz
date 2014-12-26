//
//  Functor.swift
//  swiftz
//
//  Created by Josh Abernathy on 6/7/2014.
//  Copyright (c) 2014 Josh Abernathy. All rights reserved.
//


public struct Maybe<A> {
	let value: A?

	public init(_ v : A) {
		value = v
	}

	public init() { }

	public static func just(t : A) -> Maybe<A> {
		return Maybe(t)
	}

	public static func none() -> Maybe {
		return Maybe()
	}

	public func isJust() -> Bool {
		switch value {
		case .Some(_): 
			return true
		case .None: 
			return false
		}
	}

	public func isNone() -> Bool {
		return !isJust()
	}

	public func fromJust() -> A {
		return self.value!
	}
}

extension Maybe : BooleanType {
	public var boolValue : Bool {
		return isJust()
	}
}

public func ==<A: Equatable>(lhs : Maybe<A>, rhs : Maybe<A>) -> Bool {
	if lhs.isNone() && rhs.isNone() {
		return true
	}

	if lhs && rhs {
		return lhs.fromJust() == rhs.fromJust()
	}

	return false
}

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

extension Maybe : Applicative {
	typealias FA = Maybe<A>
	typealias FAB = Maybe<A -> B>
	
	public static func pure(a : A) -> Maybe<A>	 {
		return Maybe<A>.just(a)
	}
	
	public func ap<B>(f : Maybe<A -> B>) -> Maybe<B>	{
		if f.isJust() {
			let fn: (A -> B) = f.fromJust()
			return self.fmap(fn)
		} else {
			return Maybe<B>.none()
		}
	}
}
