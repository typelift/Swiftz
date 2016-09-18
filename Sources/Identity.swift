//
//  Identity.swift
//  Swiftz
//
//  Created by Robert Widmann on 8/19/15.
//  Copyright © 2015-2016 TypeLift. All rights reserved.
//

#if !XCODE_BUILD
	import Operadics
	import Swiftx
#endif

/// The Identity Functor holds a singular value.
public struct Identity<T> {
	private let unIdentity : () -> T

	public init(_ aa : @autoclosure @escaping () -> T) {
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

extension Identity /*: Functor*/ {
	public typealias A = T
	public typealias B = Any
	public typealias FB = Identity<B>

	public func fmap<B>(_ f : @escaping (A) -> B) -> Identity<B> {
		return Identity<B>(f(self.runIdentity))
	}
}

public func <^> <A, B>(_ f : @escaping (A) -> B, m : Identity<A>) -> Identity<B> {
	return m.fmap(f)
}

extension Identity /*: Pointed*/ {
	public static func pure(_ x : A) -> Identity<T> {
		return Identity(x)
	}
}

extension Identity /*: Applicative*/ {
	public typealias FAB = Identity<(A) -> B>

	public func ap<B>(_ f : Identity<(A) -> B>) -> Identity<B> {
		return Identity<B>(f.runIdentity(self.runIdentity))
	}
}

extension Identity /*: Cartesian*/ {
	public typealias FTOP = Identity<()>
	public typealias FTAB = Identity<(A, B)>
	public typealias FTABC = Identity<(A, B, C)>
	public typealias FTABCD = Identity<(A, B, C, D)>

	public static var unit : Identity<()> { return Identity<()>(()) }
	public func product<B>(_ r : Identity<B>) -> Identity<(A, B)> {
		return self.mzip(r)
	}
	
	public func product<B, C>(_ r : Identity<B>, _ s : Identity<C>) -> Identity<(A, B, C)> {
		return { x in { y in { z in (x, y, z) } } } <^> self <*> r <*> s
	}
	
	public func product<B, C, D>(_ r : Identity<B>, _ s : Identity<C>, _ t : Identity<D>) -> Identity<(A, B, C, D)> {
		return { x in { y in { z in { w in (x, y, z, w) } } } } <^> self <*> r <*> s <*> t
	}
}

extension Identity /*: ApplicativeOps*/ {
	public typealias C = Any
	public typealias FC = Identity<C>
	public typealias D = Any
	public typealias FD = Identity<D>

	public static func liftA<B>(_ f : @escaping (A) -> B) -> (Identity<A>) -> Identity<B> {
		return { (a : Identity<A>) -> Identity<B> in Identity<(A) -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(_ f : @escaping (A) -> (B) -> C) -> (Identity<A>) -> (Identity<B>) -> Identity<C> {
		return { (a : Identity<A>) -> (Identity<B>) -> Identity<C> in { (b : Identity<B>) -> Identity<C> in f <^> a <*> b  } }
	}

	public static func liftA3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (Identity<A>) -> (Identity<B>) -> (Identity<C>) -> Identity<D> {
		return { (a : Identity<A>) -> (Identity<B>) -> (Identity<C>) -> Identity<D> in { (b : Identity<B>) -> (Identity<C>) -> Identity<D> in { (c : Identity<C>) -> Identity<D> in f <^> a <*> b <*> c } } }
	}
}

public func <*> <A, B>(_ f : Identity<(A) -> B>, m : Identity<A>) -> Identity<B> {
	return m.ap(f)
}

extension Identity /*: Monad*/ {
	public func bind<B>(_ f : (A) -> Identity<B>) -> Identity<B> {
		return f(self.runIdentity)
	}
}

public func >>- <A, B>(m : Identity<A>, f : (A) -> Identity<B>) -> Identity<B> {
	return m.bind(f)
}

extension Identity /*: MonadOps*/ {
	public static func liftM<B>(_ f : @escaping (A) -> B) -> (Identity<A>) -> Identity<B> {
		return { (m1 : Identity<A>) -> Identity<B> in m1 >>- { (x1 : A) in Identity<B>.pure(f(x1)) } }
	}

	public static func liftM2<B, C>(_ f : @escaping (A) -> (B) -> C) -> (Identity<A>) -> (Identity<B>) -> Identity<C> {
		return { (m1 : Identity<A>) -> (Identity<B>) -> Identity<C> in { (m2 : Identity<B>) -> Identity<C> in m1 >>- { (x1 : A) in m2 >>- { (x2 :B) in Identity<C>.pure(f(x1)(x2)) } } } }
	}

	public static func liftM3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (Identity<A>) -> (Identity<B>) -> (Identity<C>) -> Identity<D> {
		return { (m1 : Identity<A>) -> (Identity<B>) -> (Identity<C>) -> Identity<D> in { (m2 : Identity<B>) -> (Identity<C>) -> Identity<D> in { (m3 : Identity<C>) -> Identity<D> in m1 >>- { (x1 : A) in m2 >>- { (x2 : B) in m3 >>- { (x3 : C) in Identity<D>.pure(f(x1)(x2)(x3)) } } } } } }
	}
}

public func >>->> <A, B, C>(_ f : @escaping (A) -> Identity<B>, g : @escaping (B) -> Identity<C>) -> ((A) -> Identity<C>) {
	return { x in f(x) >>- g }
}

public func <<-<< <A, B, C>(g : @escaping (B) -> Identity<C>, f : @escaping (A) -> Identity<B>) -> ((A) -> Identity<C>) {
	return f >>->> g
}

extension Identity /*: MonadZip*/ {
	public typealias FTABL = Identity<(A, B)>

	public func mzip<B>(_ other : Identity<B>) -> Identity<(A, B)> {
		return Identity<(A, B)>((self.runIdentity, other.runIdentity))
	}

	public func mzipWith<B, C>(other : Identity<B>, _ f : @escaping (A) -> (B) -> C) -> Identity<C> {
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

extension Identity /*: Comonad*/ {
	public func duplicate() -> Identity<Identity<T>> {
		return Identity<Identity<T>>(self)
	}

	public func extend<B>(_ f : @escaping (Identity<T>) -> B) -> Identity<B> {
		return self.duplicate().fmap(f)
	}
}

public func sequence<A>(_ ms : [Identity<A>]) -> Identity<[A]> {
	return ms.reduce(Identity<[A]>.pure([]), { n, m in
		return n.bind { xs in
			return m.bind { x in
				return Identity<[A]>.pure(xs + [x])
			}
		}
	})
}
