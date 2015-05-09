//
//  Iso.swift
//  swiftz
//
//  Created by Alexander Ronald Altman on 7/22/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// Captures an isomorphism between S and A and
public struct Iso<S, T, A, B> {
	public let get : S -> A
	public let inject : B -> T

	/// Builds an Iso from a pair of inverse functions.
	public init(get : S -> A, inject : B -> T) {
		self.get = get
		self.inject = inject
	}

	
	public func modify(v : S, _ f : A -> B) -> T {
		return inject(f(get(v)))
	}

	public var asLens : Lens<S, T, A, B> {
		return Lens { s in IxStore(self.get(s)) { self.inject($0) } }
	}

	public var asPrism : Prism<S, T, A, B> {
		return Prism(tryGet: { .Some(self.get($0)) }, inject: inject)
	}
}

/// The identity isomorphism.
public func identity<S, T>() -> Iso<S, T, S, T> {
	return Iso(get: identity, inject: identity)
}

/// Compose isomorphisms.
public func • <S, T, I, J, A, B>(i1 : Iso<S, T, I, J>, i2 : Iso<I, J, A, B>) -> Iso<S, T, A, B> {
	return Iso(get: i2.get • i1.get, inject: i1.inject • i2.inject)
}

/// Compose isomorphisms.
public func comp<S, T, I, J, A, B>(i1 : Iso<S, T, I, J>)(i2 : Iso<I, J, A, B>) -> Iso<S, T, A, B> {
	return i1 • i2
}

/// MARK: Box iso

/// An isomorphism between Box and its underlying type.
public func isoBox<A, B>() -> Iso<Box<A>, Box<B>, A, B> {
	return Iso(get: { $0.value }, inject: { Box($0) } )
}

/// MARK: Functor base types

/// An isomorphism between the Identity Functor and its underlying type.
public func isoId<A, B>() -> Iso<Id<A>, Id<B>, A, B> {
	return Iso(get: { $0.runId }, inject: { Id($0) })
}

/// An isomorphism between the Const Functor and its underlying type.
public func isoConst<A, B, X>() -> Iso<Const<A, X>, Const<B, X>, A, B> {
	return Iso(get: { $0.runConst }, inject: { Const($0) })
}
