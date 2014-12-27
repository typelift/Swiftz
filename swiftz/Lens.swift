//
//  Lens.swift
//  swiftz
//
//  Created by Maxwell Swadling on 8/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

public struct Lens<S, T, A, B> {
	public let run: S -> IxStore<A, B, T>

	public init(_ run: S -> IxStore<A, B, T>) {
		self.run = run
	}

	public init(get: S -> A, set: (S, B) -> T) {
		self.init({ v in IxStore(get(v)) { set(v, $0) } })
	}

	public init(get: S -> A, modify: (S, A -> B) -> T) {
		self.init(get: get, set: { v, x in modify(v) { _ in x } })
	}

	public func get(v: S) -> A {
		return run(v).pos
	}

	public func set(v: S, _ x: B) -> T {
		return run(v).peek(x)
	}

	public func modify(v: S, _ f: A -> B) -> T {
		let q = run(v)
		return q.peek(f(q.pos))
	}

	public func zoom<X>(a: IxState<A, B, X>) -> IxState<S, T, X> {
		return IxState { s1 in
			let q = self.run(s1)
			let (x, s2) = a.run(q.pos)
			return (x, q.peek(s2))
		}
	}
}

public func •<S, T, I, J, A, B>(l1: Lens<S, T, I, J>, l2: Lens<I, J, A, B>) -> Lens<S, T, A, B> {
	return Lens { v in
		let q1 = l1.run(v)
		let q2 = l2.run(q1.pos)
		return IxStore(q2.pos) { q1.peek(q2.peek($0)) }
	}
}

public func comp<S, T, I, J, A, B>(l1: Lens<S, T, I, J>)(l2: Lens<I, J, A, B>) -> Lens<S, T, A, B> {
	return l1 • l2
}
