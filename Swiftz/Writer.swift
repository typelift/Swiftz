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

extension Writer : ApplicativeOps {
	public typealias C = Any
	public typealias FC = Writer<W, C>
	public typealias D = Any
	public typealias FD = Writer<W, D>

	public static func liftA<B>(f : A -> B) -> Writer<W, A> -> Writer<W, B> {
		return { a in Writer<W, A -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(f : A -> B -> C) -> Writer<W, A> -> Writer<W, B> -> Writer<W, C> {
		return { a in { b in f <^> a <*> b  } }
	}

	public static func liftA3<B, C, D>(f : A -> B -> C -> D) -> Writer<W, A> -> Writer<W, B> -> Writer<W, C> -> Writer<W, D> {
		return { a in { b in { c in f <^> a <*> b <*> c } } }
	}
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

extension Writer : MonadOps {
	public static func liftM<B>(f : A -> B) -> Writer<W, A> -> Writer<W, B> {
		return { m1 in m1 >>- { x1 in Writer<W, B>.pure(f(x1)) } }
	}

	public static func liftM2<B, C>(f : A -> B -> C) -> Writer<W, A> -> Writer<W, B> -> Writer<W, C> {
		return { m1 in { m2 in m1 >>- { x1 in m2 >>- { x2 in Writer<W, C>.pure(f(x1)(x2)) } } } }
	}

	public static func liftM3<B, C, D>(f : A -> B -> C -> D) -> Writer<W, A> -> Writer<W, B> -> Writer<W, C> -> Writer<W, D> {
		return { m1 in { m2 in { m3 in m1 >>- { x1 in m2 >>- { x2 in m3 >>- { x3 in Writer<W, D>.pure(f(x1)(x2)(x3)) } } } } } }
	}
}

public func >>->> <W : Monoid, A, B, C>(f : A -> Writer<W, B>, g : B -> Writer<W, C>) -> (A -> Writer<W, C>) {
	return { x in f(x) >>- g }
}

public func <<-<< <W : Monoid, A, B, C>(g : B -> Writer<W, C>, f : A -> Writer<W, B>) -> (A -> Writer<W, C>) {
	return f >>->> g
}

public func == <W : protocol<Monoid, Equatable>, A : Equatable>(l : Writer<W, A>, r : Writer<W, A>) -> Bool {
	let (a, w) = l.runWriter
	let (a2, w2) = r.runWriter
	return (a == a2) && (w == w2)
}

public func != <W : protocol<Monoid, Equatable>, A : Equatable>(l : Writer<W, A>, r : Writer<W, A>) -> Bool {
	return !(l == r)
}

