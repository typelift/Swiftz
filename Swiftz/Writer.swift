//
//  Writer.swift
//  Swiftz
//
//  Created by Robert Widmann on 8/14/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

public struct Writer<W : Monoid, T> {
	public let runWriter : (T, W)
	
	public init(_ runWriter : (T, W)) {
		self.runWriter = runWriter
	}
	
	public func mapWriter<U, V : Monoid>(f : (T, W) -> (U, V)) -> Writer<V, U> {
		return Writer<V, U>(f(self.runWriter))
	}
	
	public var exec : W {
		return self.runWriter.1
	}
}

public func tell<W : Monoid>(w : W) -> Writer<W, ()> {
	return Writer(((), w))
}

public func listen<W : Monoid, A>(w : Writer<W, A>) -> Writer<W, (A, W)> {
	let (a, w) = w.runWriter
	return Writer(((a, w), w))
}

public func listens<W : Monoid, A, B>(f : W -> B, w : Writer<W, A>) -> Writer<W, (A, B)> {
	let (a, w) = w.runWriter
	return Writer(((a, f(w)), w))
}

public func pass<W : Monoid, A>(w : Writer<W, (A, W -> W)>) -> Writer<W, A> {
	let ((a, f), w) = w.runWriter
	return Writer((a, f(w)))
}

public func censor<W : Monoid, A>(f : W -> W, w : Writer<W, A>) -> Writer<W, A> {
	let (a, w) = w.runWriter
	return Writer((a, f(w)))
}

extension Writer : Functor {
	public typealias B = Any
	public typealias FB = Writer<W, B>
	
	public func fmap<B>(f : A -> B) -> Writer<W, B> {
		return self.mapWriter { (a, w) in (f(a), w) }
	}
}

public func <^> <W : Monoid, A, B>(f : A -> B, w : Writer<W, A>) -> Writer<W, B> {
	return w.fmap(f)
}

extension Writer : Pointed {
	public typealias A = T
	
	public static func pure<W : Monoid, A>(x: A) -> Writer<W, A> {
		return Writer<W, A>((x, W.mempty))
	}
}

extension Writer : Applicative {
	public typealias FAB = Writer<W, A -> B>
	
	public func ap(fs : Writer<W, A -> B>) -> Writer<W, B> {
		return fs <*> self
	}
}

public func <*> <W : Monoid, A, B>(wfs : Writer<W, A -> B>, xs : Writer<W, A>) -> Writer<W, B>  {
	return wfs.bind(Writer.fmap(xs))
}

extension Writer : Monad {
	public func bind<B>(f : A -> Writer<W, B>) -> Writer<W, B> {
		return self >>- f
	}
}

public func >>- <W, A, B>(x : Writer<W, A>, f : A -> Writer<W, B>) -> Writer<W,B> {
	let (a, w) = x.runWriter
	let (a2, w2) = f(a).runWriter
	return Writer((a2, w <> w2))
}

public func == <W : protocol<Monoid, Equatable>, A : Equatable>(l : Writer<W, A>, r : Writer<W, A>) -> Bool {
	let (a, w) = l.runWriter
	let (a2, w2) = r.runWriter
	return (a == a2) && (w == w2)
}

public func != <W : protocol<Monoid, Equatable>, A : Equatable>(l : Writer<W, A>, r : Writer<W, A>) -> Bool {
	return !(l == r)
}

