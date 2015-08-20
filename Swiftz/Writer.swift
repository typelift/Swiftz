//
//  Writer.swift
//  Swiftz
//
//  Created by Robert Widmann on 8/14/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

/// The `Writer` Monad represents a computation that appends (writes) to an associated `Monoid` 
/// value as it evaluates.
///
/// `Writer` is most famous for allowing the accumulation of log output during program execution.
public struct Writer<W : Monoid, T> {
	/// Extracts the current value and environment.
	public let runWriter : (T, W)
	
	public init(_ runWriter : (T, W)) {
		self.runWriter = runWriter
	}
	
	/// Returns a `Writer` that applies the function to its current value and environment.
	public func mapWriter<U, V : Monoid>(f : (T, W) -> (U, V)) -> Writer<V, U> {
		return Writer<V, U>(f(self.runWriter))
	}
	
	/// Extracts the current environment from the receiver.
	public var exec : W {
		return self.runWriter.1
	}
}

/// Appends the given value to the `Writer`'s environment.
public func tell<W : Monoid>(w : W) -> Writer<W, ()> {
	return Writer(((), w))
}

/// Executes the action of the given `Writer` and adds its output to the result of the computation.
public func listen<W : Monoid, A>(w : Writer<W, A>) -> Writer<W, (A, W)> {
	let (a, w) = w.runWriter
	return Writer(((a, w), w))
}

/// Executes the action of the given `Writer` then applies the function to the produced environment
/// and adds the overall output to the result of the computation.
public func listens<W : Monoid, A, B>(f : W -> B, w : Writer<W, A>) -> Writer<W, (A, B)> {
	let (a, w) = w.runWriter
	return Writer(((a, f(w)), w))
}

/// Executes the action of the given `Writer` to get a value and a function.  The function is then
/// applied to the current environment and the output added to the result of the computation.
public func pass<W : Monoid, A>(w : Writer<W, (A, W -> W)>) -> Writer<W, A> {
	let ((a, f), w) = w.runWriter
	return Writer((a, f(w)))
}

/// Executes the actino of the given `Writer` and applies the given function to its environment,
/// leaving the value produced untouched.
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

