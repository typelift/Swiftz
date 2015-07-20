//
//  Identity.swift
//  Swiftz
//
//  Created by Robert Widmann on 7/20/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

/// The Identity Functor holds a singular value.
public struct Identity<A> {
	private let a : () -> A
	
	public init(@autoclosure(escaping) _ aa : () -> A) {
		a = aa
	}
	
	public var runIdentity : A {
		return a()
	}
}

extension Identity : Functor {
	typealias B = Any
	typealias FB = Identity<B>
	
	public func fmap<B>(f : A -> B) -> Identity<B> {
		return Identity<B>(f(self.runIdentity))
	}
}

extension Identity : Pointed {
	public static func pure(x : A) -> Identity<A> {
		return Identity(x)
	}
}

extension Identity : Applicative {
	typealias FAB = Identity<A -> B>
	public func ap<B>(f : Identity<A -> B>) -> Identity<B> {
		return Identity<B>(f.runIdentity(self.runIdentity))
	}
}

extension Identity : Monad {
	public func bind<B>(f : A -> Identity<B>) -> Identity<B> {
		return f(self.runIdentity)
	}
}

extension Identity : MonadZip {
	typealias C = Any
	typealias FC = Identity<C>
	typealias FTAB = Identity<(A, B)>
	
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
	typealias FFA = Identity<Identity<A>>
	
	public func duplicate() -> Identity<Identity<A>> {
		return Identity<Identity<A>>(self)
	}
	
	public func extend<B>(f : Identity<A> -> B) -> Identity<B> {
		return self.duplicate().fmap(f)
	}
}
