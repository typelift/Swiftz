//
//  Function.swift
//  swiftz
//
//  Created by Robert Widmann on 1/18/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

/// The type of a function from T -> U.
public struct Function<T, U> {
	typealias A = T
	typealias B = U
	typealias C = Any

	let ap : T -> U

	public init(_ apply : T -> U) {
		self.ap = apply
	}

	public func apply(x : T) -> U {
		return self.ap(x)
	}
}

extension Function : Category {
	typealias CAA = Function<A, A>
	typealias CBC = Function<B, C>
	typealias CAC = Function<A, C>

	public static func id() -> Function<T, T> {
		return Function<T, T>({ $0 })
	}
}

public func • <A, B, C>(c : Function<B, C>, c2 : Function<A, B>) -> Function<A, C> {
	return Function.arr { c.apply(c2.apply($0)) }
}

public func <<< <A, B, C>(c1 : Function<B, C>, c2 : Function<A, B>) -> Function<A, C> {
	return c1 • c2
}

public func >>> <A, B, C>(c1 : Function<A, B>, c2 : Function<B, C>) -> Function<A, C> {
	return c2 • c1
}

extension Function : Arrow {
	typealias D = T
	typealias E = Swift.Any

	typealias FIRST = Function<(A, D), (B, D)>
	typealias SECOND = Function<(D, A), (D, B)>

	typealias ADE = Function<D, E>
	typealias SPLIT = Function<(A, D), (B, E)>

	typealias ABD = Function<A, D>
	typealias FANOUT = Function<A, (B, D)>

	public static func arr(f : T -> U) -> Function<A, B> {
		return Function<A, B>(f)
	}

	public func first() -> Function<(T, T), (U, T)> {
		return self *** Function.id()
	}

	public func second() -> Function<(T, T), (T, U)> {
		return Function.id() *** self
	}
}

public func *** <B, C, D, E>(f : Function<B, C>, g : Function<D, E>) -> Function<(B, D), (C, E)> {
	return Function.arr { (x, y) in  (f.apply(x), g.apply(y)) }
}

public func &&& <A, B, C>(f : Function<A, B>, g : Function<A, C>) -> Function<A, (B, C)> {
	return Function.arr { b in (b, b) } >>> f *** g
}

extension Function : ArrowChoice {
	typealias LEFT = Function<Either<A, D>, Either<B, D>>
	typealias RIGHT = Function<Either<D, A>, Either<D, B>>

	typealias SPLAT = Function<Either<A, D>, Either<B, E>>

	typealias ACD = Function<B, D>
	typealias FANIN = Function<Either<A, B>, D>

	public func left() -> Function<Either<A, D>, Either<B, D>> {
		return self +++ Function.id()
	}

	public func right() -> Function<Either<D, A>, Either<D, B>> {
		return Function.id() +++ self
	}
}

public func +++<B, C, D, E>(f : Function<B, C>, g : Function<D, E>) -> Function<Either<B, D>, Either<C, E>> {
	return Function.arr({ Either.left(f.apply($0)) }) ||| Function.arr({ Either.right(g.apply($0)) })
}

public func |||<B, C, D>(f : Function<B, D>, g : Function<C, D>) -> Function<Either<B, C>, D> {
	return Function.arr({ e in e.either({ f.apply($0) }, { g.apply($0) }) })
}

extension Function : ArrowApply {
	typealias APP = Function<(Function<A, B>, A), B>

	public static func app() -> Function<(Function<T, U>, A), B> {
		return Function<(Function<T, U>, A), B>({ (f, x) in f.apply(x) })
	}
}

extension Function : ArrowLoop {
	typealias LOOP = Function<(A, D), (B, D)>

	public static func loop<B, C>(f : Function<(B, D), (C, D)>) -> Function<B, C> {
		return Function<B, C>.arr { k in Function.loop(f).apply(k) }
	}
}
