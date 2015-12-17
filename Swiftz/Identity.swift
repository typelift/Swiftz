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

public func != <T : Equatable>(l : Identity<T>, r : Identity<T>) -> Bool {
	return !(l == r)
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

extension Identity : ApplicativeOps {
	public typealias C = Any
	public typealias FC = Identity<C>
	public typealias D = Any
	public typealias FD = Identity<D>

	public static func liftA<B>(f : A -> B) -> Identity<A> -> Identity<B> {
		return { a in Identity<A -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(f : A -> B -> C) -> Identity<A> -> Identity<B> -> Identity<C> {
		return { a in { b in f <^> a <*> b  } }
	}

	public static func liftA3<B, C, D>(f : A -> B -> C -> D) -> Identity<A> -> Identity<B> -> Identity<C> -> Identity<D> {
		return { a in { b in { c in f <^> a <*> b <*> c } } }
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

extension Identity : MonadOps {
	public static func liftM<B>(f : A -> B) -> Identity<A> -> Identity<B> {
		return { m1 in m1 >>- { x1 in Identity<B>.pure(f(x1)) } }
	}

	public static func liftM2<B, C>(f : A -> B -> C) -> Identity<A> -> Identity<B> -> Identity<C> {
		return { m1 in { m2 in m1 >>- { x1 in m2 >>- { x2 in Identity<C>.pure(f(x1)(x2)) } } } }
	}

	public static func liftM3<B, C, D>(f : A -> B -> C -> D) -> Identity<A> -> Identity<B> -> Identity<C> -> Identity<D> {
		return { m1 in { m2 in { m3 in m1 >>- { x1 in m2 >>- { x2 in m3 >>- { x3 in Identity<D>.pure(f(x1)(x2)(x3)) } } } } } }
	}
}

public func >>->> <A, B, C>(f : A -> Identity<B>, g : B -> Identity<C>) -> (A -> Identity<C>) {
	return { x in f(x) >>- g }
}

public func <<-<< <A, B, C>(g : B -> Identity<C>, f : A -> Identity<B>) -> (A -> Identity<C>) {
	return f >>->> g
}

extension Identity : MonadZip {
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
