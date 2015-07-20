//
//  Proxy.swift
//  Swiftz
//
//  Created by Robert Widmann on 7/20/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

/// A `Proxy` type is used to bear witness to some type variable. It is used when you want to pass
/// around proxy values for doing things like modelling type applications or faking GADTs as in
/// ~(https://gist.github.com/jckarter/cff22c8b1dcb066eaeb2).
public struct Proxy<T> { public init() {} }

extension Proxy : Equatable {}

public func == <T>(_ : Proxy<T>, _ : Proxy<T>) -> Bool {
	return true
}

public func != <T>(_ : Proxy<T>, _ : Proxy<T>) -> Bool {
	return false
}

extension Proxy : CustomStringConvertible {
	public var description : String {
		return "Proxy"
	}
}

extension Proxy : Bounded {
	public static func minBound() -> Proxy<T> {
		return Proxy()
	}
	
	public static func maxBound() -> Proxy<T> {
		return Proxy()
	}
}

extension Proxy : Semigroup {
	public func op(_ : Proxy<T>) -> Proxy<T> {
		return Proxy()
	}
}

extension Proxy : Monoid {
	public static var mzero : Proxy<T> {
		return Proxy()
	}
}

extension Proxy : Functor {
	typealias A = T
	typealias B = T
	typealias FB = Proxy<B>
	
	public func fmap<B>(f : A -> B) -> Proxy<B> {
		return Proxy<B>()
	}
}

public func <^> <A, B>(f : A -> B, l : Proxy<A>) -> Proxy<B> {
	return Proxy()
}

extension Proxy : Pointed {
	public static func pure(_ : A) -> Proxy<T> {
		return Proxy()
	}
}

extension Proxy : Applicative {
	typealias FAB = Proxy<A -> B>
	
	public func ap<B>(f : Proxy<A -> B>) -> Proxy<B> {
		return Proxy<B>()
	}
}

public func <*> <A, B>(f : Proxy<(A -> B)>, l : Proxy<A>) -> Proxy<B> {
	return Proxy()
}

extension Proxy : Monad {
	public func bind<B>(f : A -> Proxy<B>) -> Proxy<T> {
		return Proxy()
	}
}

public func >>- <A, B>(l : Proxy<A>, f : A -> Proxy<B>) -> Proxy<A> {
	return Proxy()
}

/// Uses the proxy to bear witness to the type of the first argument.  Useful in cases where the
/// type is too polymorphic for the compiler to infer.
public func asProxyTypeOf<T>(x : T, _ proxy : Proxy<T>) -> T {
	return const(x)(proxy)
}
