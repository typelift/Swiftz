//
//  ST.swift
//  swiftz
//
//  Created by Robert Widmann on 8/23/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation
import swiftz_core

// The strict state-transformer monad.  ST<S, A> represents
// a computation returning a value of type A using some internal
// context of type S.
public struct ST<S, A> {
	typealias B = S

	private var apply:(s: World<RealWorld>) -> (World<RealWorld>, A)

	internal init(apply:(s: World<RealWorld>) -> (World<RealWorld>, A)) {
		self.apply = apply
	}

    // Returns the value after completing all transformations.
	public func runST() -> A {
		let (_, x) = self.apply(s: realWorld)
		return x
	}

    // Leave this here.  Swiftc doesn't like producing an Applicative
    // or Monad extension for this quite yet.
	public static func pure<S, A>(a: A) -> ST<S, A> {
		return ST<S, A>(apply: { (let s) in
			return (s, a)
		})
	}

	public func ap(fn: ST<S, A -> B>) -> ST<S, B> {
		return ST<S, B>(apply: { (let s) in
			let (nw, f) = fn.apply(s: s)
			return (nw, f(self.runST()))
		})
	}

	public func bind<B>(f: A -> ST<S, B>) -> ST<S, B> {
		return f(runST())
	}
}

extension ST : Functor {
	public func fmap<B>(f: (A -> B)) -> ST<S, B> {
		return ST<S, B>(apply: { (let s) in
			let (nw, x) = self.apply(s: s)
			return (nw, f(x))
		})
	}
}

public func >>=<S, A, B>(x : ST<S, A>, f : A -> ST<S, B>) -> ST<S, B> {
	return x.bind(f)
}

public func >><S, A, B>(x : ST<S, A>, y : ST<S, B>) -> ST<S, B> {
	return x.bind({ (_) in
		return y
	})
}

// Shifts an ST computation into the IO monad.  Only ST's indexed
// by the real world qualify to be converted.
internal func stToIO<A>(m: ST<RealWorld, A>) -> IO<A> {
  return IO<A>.pure(m.runST())
}
