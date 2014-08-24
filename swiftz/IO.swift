//
//  IO.swift
//  swiftz
//
//  Created by Robert Widmann on 8/23/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation
import swiftz_core

public struct IO<A> {
	let apply: (rw: World<RealWorld>) -> (World<RealWorld>, A)

	func unsafePerformIO() -> A  {
		return self.apply(rw: realWorld).1
	}

	public func bind<B>(f: A -> IO<B>) -> IO<B> {
		return IO<B>({ (let rw) in
			let (nw, a) = self.apply(rw: rw)
			return f(a).apply(rw: nw)
		})
	}

	public func map<B>(f : A -> B) -> IO<B> {
		return IO<B>({ (let rw) in
			let (nw, a) = self.apply(rw: rw)
			return (nw, f(a))
		})
	}
}


extension IO : Functor {
	typealias B = Any
	public func fmap<B>(f: (A -> B)) -> IO<B> {
		return self.map(f)
	}
}

extension IO : Applicative {
	public static func pure(a: A) -> IO<A> {
		return IO<A>({ (let rw) in
			return (rw, a)
		})
	}

	public func ap<B>(fn: IO<A -> B>) -> IO<B> {
		return IO<B>({ (let rw) in
			let f = fn.unsafePerformIO()
			let (nw, x) = self.apply(rw: rw)
			return (nw, f(x))
		})
	}
}

public func >>=<A, B>(x : IO<A>, f : A -> IO<B>) -> IO<B> {
	return x.bind(f)
}

public func >><A, B>(x : IO<A>, y : IO<B>) -> IO<B> {
	return x.bind({ (_) in
		return y
	})
}

public func <-<A, B>(inout lhs : A, rhs : IO<A>) {
	lhs = rhs.unsafePerformIO()
}

public func join<A>(rs: IO<IO<A>>) -> IO<A> {
	return rs.unsafePerformIO()
}


/// Herein lies the real world.  It is incredibly magic and sacred and not to be touched.  Those who
/// do rarely come out alive...
internal struct World<A> {}
internal protocol RealWorld {}

internal let realWorld = World<RealWorld>()
