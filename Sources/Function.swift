//
//  Function.swift
//  Swiftz
//
//  Created by Robert Widmann on 1/18/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

#if !XCODE_BUILD
	import Operadics
	import Swiftx
#endif

/// The type of a function from `T` to `U`.
public struct Function<T, U> {
	public typealias A = T
	public typealias B = U
	public typealias C = Any

	let ap : (T) -> U

	public init(_ apply : @escaping (T) -> U) {
		self.ap = apply
	}

	public func apply(_ x : T) -> U {
		return self.ap(x)
	}
}

extension Function : Category {
	public typealias CAA = Function<A, A>
	public typealias CBC = Function<B, C>
	public typealias CAC = Function<A, C>

	public static func id() -> Function<T, T> {
		return Function<T, T>(identity)
	}
}

public func • <A, B, C>(c : Function<B, C>, c2 : Function<A, B>) -> Function<A, C> {
	return Function.arr(c.apply • c2.apply)
}

public func <<< <A, B, C>(c1 : Function<B, C>, c2 : Function<A, B>) -> Function<A, C> {
	return c1 • c2
}

public func >>> <A, B, C>(c1 : Function<A, B>, c2 : Function<B, C>) -> Function<A, C> {
	return c2 • c1
}

extension Function /*: Arrow*/ {
	public typealias D = T
	public typealias E = Any

	public typealias FIRST = Function<(A, D), (B, D)>
	public typealias SECOND = Function<(D, A), (D, B)>

	public typealias ADE = Function<D, E>
	public typealias SPLIT = Function<(A, D), (B, E)>

	public typealias ABD = Function<A, D>
	public typealias FANOUT = Function<A, (B, D)>

	public static func arr(_ f : @escaping (T) -> U) -> Function<A, B> {
		return Function<A, B>(f)
	}

	public func first() -> Function<(T, T), (U, T)> {
		return self *** Function.id()
	}

	public func second() -> Function<(T, T), (T, U)> {
		return Function.id() *** self
	}
}

public func *** <B, C, D, E>(_ f : Function<B, C>, g : Function<D, E>) -> Function<(B, D), (C, E)> {
	return Function.arr { (x, y) in  (f.apply(x), g.apply(y)) }
}

public func &&& <A, B, C>(_ f : Function<A, B>, g : Function<A, C>) -> Function<A, (B, C)> {
	return Function.arr { b in (b, b) } >>> f *** g
}

extension Function /*: ArrowChoice*/ {
	public typealias LEFT = Function<Either<A, D>, Either<B, D>>
	public typealias RIGHT = Function<Either<D, A>, Either<D, B>>

	public typealias SPLAT = Function<Either<A, D>, Either<B, E>>

	public typealias ACD = Function<B, D>
	public typealias FANIN = Function<Either<A, B>, D>

	public func left() -> Function<Either<A, D>, Either<B, D>> {
		return self +++ Function.id()
	}

	public func right() -> Function<Either<D, A>, Either<D, B>> {
		return Function.id() +++ self
	}
}

public func +++<B, C, D, E>(_ f : Function<B, C>, g : Function<D, E>) -> Function<Either<B, D>, Either<C, E>> {
	return Function.arr(Either.Left • f.apply) ||| Function.arr(Either.Right • g.apply)
}

public func |||<B, C, D>(_ f : Function<B, D>, g : Function<C, D>) -> Function<Either<B, C>, D> {
	return Function.arr({ e in e.either(onLeft: f.apply, onRight: g.apply) })
}

extension Function /*: ArrowApply*/ {
	public typealias APP = Function<(Function<A, B>, A), B>

	public static func app() -> Function<(Function<T, U>, A), B> {
		return Function<(Function<T, U>, A), B>({ (f, x) in f.apply(x) })
	}
}

extension Function /*: ArrowLoop*/ {
	public typealias LOOP = Function<(A, D), (B, D)>

	public static func loop<B, C>(_ f : Function<(B, D), (C, D)>) -> Function<B, C> {
		return Function<B, C>.arr(Function.loop(f).apply)
	}
}
