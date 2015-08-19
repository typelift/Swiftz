//
//  Identity.swift
//  Swiftz
//
//  Created by Robert Widmann on 8/19/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

/// The Identity Functor holds a singular value.
public struct Identity<A> {
	private let unIdentity : () -> A
	
	public init(@autoclosure(escaping) _ aa : () -> A) {
		unIdentity = aa
	}
	
	public var runIdentity : A {
		return unIdentity()
	}
}

extension Identity : Functor {
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
	public static func pure(x : A) -> Identity<A> {
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

extension Identity : Copointed {
	public func extract() -> A {
		return self.runIdentity
	}
}

extension Identity : Comonad {
	public typealias FFA = Identity<Identity<A>>
	
	public func duplicate() -> Identity<Identity<A>> {
		return Identity<Identity<A>>(self)
	}
	
	public func extend<B>(f : Identity<A> -> B) -> Identity<B> {
		return self.duplicate().fmap(f)
	}
}
