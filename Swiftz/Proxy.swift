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
	public static var mempty : Proxy<T> {
		return Proxy()
	}
}

extension Proxy : Functor {
	public typealias A = T
	public typealias B = T
	public typealias FB = Proxy<B>
	
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
	public typealias FAB = Proxy<A -> B>
	
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

extension Proxy : MonadZip {
	public typealias C = T
	public typealias FC = Proxy<C>
	public typealias FTAB = Proxy<(A, B)>
	
	public func mzip<B>(_ : Proxy<T>) -> Proxy<(A, B)> {
		return Proxy<(A, B)>()
	}
	
	public func mzipWith<B, C>(_ : FB, _ : A -> B -> C) -> Proxy<T> {
		return Proxy()
	}
	
	public static func munzip<B>(_ : Proxy<(A, B)>) -> (Proxy<T>, Proxy<T>) {
		return (Proxy(), Proxy())
	}
}

extension Proxy : Copointed {
	public func extract() -> A {
		fatalError()
	}
}

extension Proxy : Comonad {
	public typealias FFA = Proxy<Proxy<T>>
	
	public func duplicate() -> Proxy<Proxy<T>> {
		return Proxy<Proxy<T>>()
	}
	
	public func extend<B>(fab : Proxy<T> -> B) -> Proxy<B> {
		return Proxy<B>()
	}
}

/// Uses the proxy to bear witness to the type of the first argument.  Useful in cases where the
/// type is too polymorphic for the compiler to infer.
public func asProxyTypeOf<T>(x : T, _ proxy : Proxy<T>) -> T {
	return const(x)(proxy)
}
