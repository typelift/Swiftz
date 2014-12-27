//
//  IxMultiStore.swift
//  swiftz
//
//  Created by Alexander Ronald Altman on 8/4/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//


// N.B.:  This is the "inlining" of the indexed store comonad transformer
// applied to the array zipper comonad
public struct IxMultiStore<O, I, A> {
	let pos: O

	let set: ArrayZipper<I -> A>

	public init(_ pos: O, _ set: ArrayZipper<I -> A>) {
		self.pos = pos
		self.set = set
	}

	public func map<B>(f: A -> B) -> IxMultiStore<O, I, B> {
		return f <^> self
	}

	public func imap<P>(f: O -> P) -> IxMultiStore<P, I, A> {
		return f <^^> self
	}

	public func contramap<H>(f: H -> I) -> IxMultiStore<O, H, A> {
		return f <!> self
	}

	public func dup<J>() -> IxMultiStore<O, J, IxMultiStore<J, I, A>> {
		return duplicate(self)
	}

	public func extend<E, B>(f: IxMultiStore<E, I, A> -> B) -> IxMultiStore<O, E, B> {
		return self ->> f
	}

	public func put(x: I) -> ArrayZipper<A> {
		return { $0(x) } <^> set
	}

	public func puts(f: O -> I) -> ArrayZipper<A> {
		return put(f(pos))
	}

	public func peek(x: I) -> A {
		return put(x).extract()
	}

	public func peeks(f: O -> I) -> A {
		return peek(f(pos))
	}
}

public func extract<I, A>(a: IxMultiStore<I, I, A>) -> A {
	return a.set.extract()(a.pos)
}

public func <^><O, I, A, B>(f: A -> B, a: IxMultiStore<O, I, A>) -> IxMultiStore<O, I, B> {
	return IxMultiStore(a.pos, { g in { f(g($0)) } } <^> a.set)
}

public func<^^><O, P, I, A>(f: O -> P, a: IxMultiStore<O, I, A>) -> IxMultiStore<P, I, A> {
	return IxMultiStore(f(a.pos), a.set)
}

public func <!><O, H, I, A>(f: H -> I, a: IxMultiStore<O, I, A>) -> IxMultiStore<O, H, A> {
	return IxMultiStore(a.pos, { $0 • f } <^> a.set)
}

public func duplicate<O, J, I, A>(a: IxMultiStore<O, I, A>) -> IxMultiStore<O, J, IxMultiStore<J, I, A>> {
	return IxMultiStore(a.pos, a.set ->> { g in { IxMultiStore($0, g) } })
}

public func ->><O, J, I, A, B>(a: IxMultiStore<O, I, A>, f: IxMultiStore<J, I, A> -> B) -> IxMultiStore<O, J, B> {
	return IxMultiStore(a.pos, a.set ->> { g in { f(IxMultiStore($0, g)) } })
}

public func lower<I, A>(a: IxMultiStore<I, I, A>) -> ArrayZipper<A> {
	return { $0(a.pos) } <^> a.set
}

public func seek<O, P, I, A>(a: IxMultiStore<O, I, A>)(x: P) -> IxMultiStore<P, I, A> {
	return IxMultiStore(x, a.set)
}

public func seeks<O, P, I, A>(a: IxMultiStore<O, I, A>)(f: O -> P) -> IxMultiStore<P, I, A> {
	return IxMultiStore(f(a.pos), a.set)
}

