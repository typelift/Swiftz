//
//  Identity.swift
//  Swiftz
//
<<<<<<< HEAD
//  Created by Robert Widmann on 7/20/15.
=======
//  Created by Robert Widmann on 8/19/15.
>>>>>>> f9033e1bd247a1e7ab3b35b3b222a4091004b4ae
//  Copyright © 2015 TypeLift. All rights reserved.
//

/// The Identity Functor holds a singular value.
<<<<<<< HEAD
public struct Identity<A> {
	private let a : () -> A
	
	public init(@autoclosure(escaping) _ aa : () -> A) {
		a = aa
	}
	
	public var runIdentity : A {
		return a()
	}
}

/// MARK: Equatable

public func ==<A : Equatable>(lhs : Identity<A>, rhs : Identity<A>) -> Bool {
	return lhs.runIdentity == rhs.runIdentity
}

public func !=<A : Equatable>(lhs : Identity<A>, rhs : Identity<A>) -> Bool {
	return !(lhs == rhs)
}

/// MARK: Control.*

extension Identity : Functor {
=======
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
>>>>>>> f9033e1bd247a1e7ab3b35b3b222a4091004b4ae
	public typealias B = Any
	public typealias FB = Identity<B>
	
	public func fmap<B>(f : A -> B) -> Identity<B> {
		return Identity<B>(f(self.runIdentity))
	}
}

<<<<<<< HEAD
public func <^> <A, B>(f : A -> B, l : Identity<A>) -> Identity<B> {
	return l.fmap(f)
}

extension Identity : Pointed {
	public static func pure(x : A) -> Identity<A> {
=======
public func <^> <A, B>(f : A -> B, m : Identity<A>) -> Identity<B> {
	return m.fmap(f)
}

extension Identity : Pointed {
	public static func pure(x : A) -> Identity<T> {
>>>>>>> f9033e1bd247a1e7ab3b35b3b222a4091004b4ae
		return Identity(x)
	}
}

extension Identity : Applicative {
	public typealias FAB = Identity<A -> B>
	
	public func ap<B>(f : Identity<A -> B>) -> Identity<B> {
		return Identity<B>(f.runIdentity(self.runIdentity))
	}
}

<<<<<<< HEAD
public func <*> <A, B>(f : Identity<(A -> B)>, l : Identity<A>) -> Identity<B> {
	return l.ap(f)
=======
public func <*> <A, B>(f : Identity<A -> B>, m : Identity<A>) -> Identity<B> {
	return m.ap(f)
>>>>>>> f9033e1bd247a1e7ab3b35b3b222a4091004b4ae
}

extension Identity : Monad {
	public func bind<B>(f : A -> Identity<B>) -> Identity<B> {
		return f(self.runIdentity)
	}
}

<<<<<<< HEAD
public func >>- <A, B>(l : Identity<A>, f : A -> Identity<B>) -> Identity<B> {
	return l.bind(f)
}

extension Identity : MonadFix {
	public static func mfix(f : A -> Identity<A>) -> Identity<A> {
		return f(Identity.mfix(f).runIdentity)
	}
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
=======
public func >>- <A, B>(m : Identity<A>, f : A -> Identity<B>) -> Identity<B> {
	return m.bind(f)
>>>>>>> f9033e1bd247a1e7ab3b35b3b222a4091004b4ae
}

extension Identity : Copointed {
	public func extract() -> A {
		return self.runIdentity
	}
}

extension Identity : Comonad {
<<<<<<< HEAD
	public typealias FFA = Identity<Identity<A>>
	
	public func duplicate() -> Identity<Identity<A>> {
		return Identity<Identity<A>>(self)
	}
	
	public func extend<B>(f : Identity<A> -> B) -> Identity<B> {
=======
	public typealias FFA = Identity<Identity<T>>
	
	public func duplicate() -> Identity<Identity<T>> {
		return Identity<Identity<T>>(self)
	}
	
	public func extend<B>(f : Identity<T> -> B) -> Identity<B> {
>>>>>>> f9033e1bd247a1e7ab3b35b3b222a4091004b4ae
		return self.duplicate().fmap(f)
	}
}
