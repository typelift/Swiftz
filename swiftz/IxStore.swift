//
//  IxStore.swift
//  swiftz
//
//  Created by Alexander Ronald Altman on 6/12/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//


// N.B.:  In the indexed store comonad transformer, set, put, and peek are all distinct,
// as are puts and peeks.  The lack of distinction here is due to the lack of transformer
// nature; as soon as we get transformers, that will change.
public struct IxStore<O, I, A> {
	let pos: O

	let set: I -> A

	public init(_ pos: O, _ set: I -> A) {
		self.pos = pos
		self.set = set
	}

	public func map<B>(f: A -> B) -> IxStore<O, I, B> {
		return f <^> self
	}

	public func imap<P>(f: O -> P) -> IxStore<P, I, A> {
		return f <^^> self
	}

	public func contramap<H>(f: H -> I) -> IxStore<O, H, A> {
		return f <!> self
	}

	public func dup<J>() -> IxStore<O, J, IxStore<J, I, A>> {
		return duplicate(self)
	}

	public func extend<E, B>(f: IxStore<E, I, A> -> B) -> IxStore<O, E, B> {
		return self ->> f
	}

	public func put(x: I) -> A {
		return set(x)
	}

	public func puts(f: O -> I) -> A {
		return set(f(pos))
	}

	public func peek(x: I) -> A {
		return set(x)
	}

	public func peeks(f: O -> I) -> A {
		return set(f(pos))
	}
}

public func trivial<A>(x: A) -> IxStore<A, A, A> {
	return IxStore(x, identity)
}

public func extract<I, A>(a: IxStore<I, I, A>) -> A {
	return a.set(a.pos)
}

public func <^><O, I, A, B>(f: A -> B, a: IxStore<O, I, A>) -> IxStore<O, I, B> {
	return IxStore(a.pos) { f(a.set($0)) }
}

public func<^^><O, P, I, A>(f: O -> P, a: IxStore<O, I, A>) -> IxStore<P, I, A> {
	return IxStore(f(a.pos), a.set)
}

public func <!><O, H, I, A>(f: H -> I, a: IxStore<O, I, A>) -> IxStore<O, H, A> {
	return IxStore(a.pos) { a.set(f($0)) }
}

public func duplicate<O, J, I, A>(a: IxStore<O, I, A>) -> IxStore<O, J, IxStore<J, I, A>> {
	return IxStore(a.pos) { IxStore($0, a.set) }
}

public func ->><O, J, I, A, B>(a: IxStore<O, I, A>, f: IxStore<J, I, A> -> B) -> IxStore<O, J, B> {
	return IxStore(a.pos) { f(IxStore($0, a.set)) }
}

public func seek<O, P, I, A>(a: IxStore<O, I, A>)(x: P) -> IxStore<P, I, A> {
	return IxStore(x, a.set)
}

public func seeks<O, P, I, A>(a: IxStore<O, I, A>)(f: O -> P) -> IxStore<P, I, A> {
	return IxStore(f(a.pos), a.set)
}
