//
//  Identity.swift
//  Swiftz
//
//  Created by Robert Widmann on 8/19/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

/// The Identity Functor holds a singular value.
public struct Identity<T> {
	private let unIdentity : () -> T
	
	public init(@autoclosure(escaping) _ aa : () -> T) {
		unIdentity = aa
	}
	
	public var runIdentity : T {
		return unIdentity()
	}
}

public func == <T : Equatable>(l : Identity<T>, r : Identity<T>) -> Bool {
	return l.runIdentity == r.runIdentity
}

extension Identity : Functor {
	public typealias A = T
	public typealias B = Any
	public typealias FB = Identity<B>
	
	public func fmap<B>(f : A -> B) -> Identity<B> {
		return Identity<B>(f(self.runIdentity))
	}
}

public func <^> <A, B>(f : A -> B, m : Identity<A>) -> Identity<B> {
	return m.fmap(f)
}

extension Identity : Pointed {
	public static func pure(x : A) -> Identity<T> {
		return Identity(x)
	}
}

extension Identity : Applicative {
	public typealias FAB = Identity<A -> B>
	
	public func ap<B>(f : Identity<A -> B>) -> Identity<B> {
		return Identity<B>(f.runIdentity(self.runIdentity))
	}
}

public func <*> <A, B>(f : Identity<A -> B>, m : Identity<A>) -> Identity<B> {
	return m.ap(f)
}

extension Identity : Monad {
	public func bind<B>(f : A -> Identity<B>) -> Identity<B> {
		return f(self.runIdentity)
	}
}

public func >>- <A, B>(m : Identity<A>, f : A -> Identity<B>) -> Identity<B> {
	return m.bind(f)
}

extension Identity : MonadZip {
	public typealias C = Any
	public typealias FC = Identity<C>
	public typealias FTAB = Identity<(A, B)>
	
	public func mzip<B>(other : Identity<B>) -> Identity<(A, B)> {
		return Identity<(A, B)>((self.runIdentity, other.runIdentity))
	}
	
	public func mzipWith<B, C>(other : Identity<B>, _ f : A -> B -> C) -> Identity<C> {
		return Identity<C>(f(self.runIdentity)(other.runIdentity))
	}
	
	public static func munzip<B>(it : Identity<(A, B)>) -> (Identity<A>, Identity<B>) {
		return (Identity<A>(it.runIdentity.0), Identity<B>(it.runIdentity.1))
	}
}

extension Identity : Copointed {
	public func extract() -> A {
		return self.runIdentity
	}
}

extension Identity : Comonad {
	public typealias FFA = Identity<Identity<T>>
	
	public func duplicate() -> Identity<Identity<T>> {
		return Identity<Identity<T>>(self)
	}
	
	public func extend<B>(f : Identity<T> -> B) -> Identity<B> {
		return self.duplicate().fmap(f)
	}
}
