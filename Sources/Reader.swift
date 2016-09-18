//
//  Reader.swift
//  Swiftz
//
//  Created by Matthew Purland on 11/25/15.
//  Copyright © 2015-2016 TypeLift. All rights reserved.
//

#if !XCODE_BUILD
	import Operadics
	import Swiftx
#endif

/// A `Reader` monad with `R` for environment and `A` to represent the modified 
/// environment.
public struct Reader<R, A> {
	/// The function that modifies the environment
	public let reader : (R) -> A
	
	init(_ reader : @escaping (R) -> A) {
		self.reader = reader
	}
	
	/// Runs the reader and extracts the final value from it
	public func runReader(_ environment : R) -> A {
		return reader(environment)
	}
	
	/// Executes a computation in a modified environment
	public func local(_ f : @escaping (R) -> R) -> Reader<R, A> {
		return Reader(reader • f)
	}
}

public func runReader<R, A>(_ reader : Reader<R, A>) -> (R) -> A {
	return reader.runReader
}

/// Runs the reader and extracts the final value from it. This provides a global
/// function for running a reader.
public func reader<R, A>(_ f : @escaping (R) -> A) -> Reader<R, A> {
	return Reader(f)
}

/// Retrieves the monad environment
public func ask<R>() -> Reader<R, R> {
	return Reader(identity)
}

/// Retrieves a function of the current environment
public func asks<R, A>(_ f : @escaping (R) -> A) -> Reader<R, A> {
	return Reader(f)
}

extension Reader /*: Functor*/ {
	public typealias B = Any
	public typealias FB = Reader<R, B>
	
	public func fmap<B>(_ f : @escaping (A) -> B) -> Reader<R, B> {
		return Reader<R, B>(f • runReader)
	}
}

public func <^> <R, A, B>(_ f : @escaping (A) -> B, r : Reader<R, A>) -> Reader<R, B> {
	return r.fmap(f)
}

extension Reader /*: Pointed*/ {
	public static func pure(_ a : A) -> Reader<R, A> {
		return Reader<R, A> { _ in a }
	}
}

extension Reader /*: Applicative*/ {
	public typealias FAB = Reader<R, (A) -> B>
	
	public func ap(_ r : Reader<R, (A) -> B>) -> Reader<R, B> {
		return Reader<R, B>(runReader)
	}
}

public func <*> <R, A, B>(rfs : Reader<R, (A) -> B>, xs : Reader<R, A>) -> Reader<R, B>  {
	return Reader<R, B> { (environment : R) -> B in
		let a = xs.runReader(environment)
		let ab = rfs.runReader(environment)
		let b = ab(a)
		return b
	}
}

extension Reader /*: Cartesian*/ {
	public typealias FTOP = Reader<R, ()>
	public typealias FTAB = Reader<R, (A, B)>
	public typealias FTABC = Reader<R, (A, B, C)>
	public typealias FTABCD = Reader<R, (A, B, C, D)>
	
	public static var unit : Reader<R, ()> { return Reader<R, ()> { _ in () } }
	public func product<B>(r : Reader<R, B>) -> Reader<R, (A, B)> {
		return Reader<R, (A, B)> { c in
			return (self.runReader(c), r.runReader(c))
		}
	}
	
	public func product<B, C>(r : Reader<R, B>, _ s : Reader<R, C>) -> Reader<R, (A, B, C)> {
		return Reader<R, (A, B, C)> { c in
			return (self.runReader(c), r.runReader(c), s.runReader(c))
		}
	}
	
	public func product<B, C, D>(r : Reader<R, B>, _ s : Reader<R, C>, _ t : Reader<R, D>) -> Reader<R, (A, B, C, D)> {
		return Reader<R, (A, B, C, D)> { c in
			return (self.runReader(c), r.runReader(c), s.runReader(c), t.runReader(c))
		}
	}
}

extension Reader /*: ApplicativeOps*/ {
	public typealias C = Any
	public typealias FC = Reader<R, C>
	public typealias D = Any
	public typealias FD = Reader<R, D>
	
	public static func liftA(_ f : @escaping (A) -> B) -> (Reader<R, A>) -> Reader<R, B> {
		return { (a : Reader<R, A>) -> Reader<R, B> in Reader<R, (A) -> B>.pure(f) <*> a }
	}
	
	public static func liftA2(_ f : @escaping (A) -> (B) -> C) -> (Reader<R, A>) -> (Reader<R, B>) -> Reader<R, C> {
		return { (a : Reader<R, A>) -> (Reader<R, B>) -> Reader<R, C> in { (b : Reader<R, B>) -> Reader<R, C> in f <^> a <*> b  } }
	}
	
	public static func liftA3(_ f : @escaping (A) -> (B) -> (C) -> D) -> (Reader<R, A>) -> (Reader<R, B>) -> (Reader<R, C>) -> Reader<R, D> {
		return { (a : Reader<R, A>) -> (Reader<R, B>) -> (Reader<R, C>) -> Reader<R, D> in { (b : Reader<R, B>) -> (Reader<R, C>) -> Reader<R, D> in { (c : Reader<R, C>) -> Reader<R, D> in f <^> a <*> b <*> c } } }
	}
}

extension Reader /*: Monad*/ {
	public func bind(_ f : @escaping (A) -> Reader<R, B>) -> Reader<R, B> {
		return self >>- f
	}
}

public func >>- <R, A, B>(r : Reader<R, A>, f : @escaping (A) -> Reader<R, B>) -> Reader<R, B> {
	return Reader<R, B> { (environment : R) -> B in
		let a = r.runReader(environment)
		let readerB = f(a)
		return readerB.runReader(environment)
	}
}

extension Reader /*: MonadOps*/ {
	public static func liftM(_ f : @escaping (A) -> B) -> (Reader<R, A>) -> Reader<R, B> {
		return { (m1 : Reader<R, A>) -> Reader<R, B> in m1 >>- { (x1 : A) in Reader<R, B>.pure(f(x1)) } }
	}
	
	public static func liftM2(_ f : @escaping (A) -> (B) -> C) -> (Reader<R, A>) -> (Reader<R, B>) -> Reader<R, C> {
		return { (m1 : Reader<R, A>) -> (Reader<R, B>) -> Reader<R, C> in { (m2 : Reader<R, B>) -> Reader<R, C> in m1 >>- { (x1 : A) in m2 >>- { (x2 : B) in Reader<R, C>.pure(f(x1)(x2)) } } } }
	}
	
	public static func liftM3(_ f : @escaping (A) -> (B) -> (C) -> D) -> (Reader<R, A>) -> (Reader<R, B>) -> (Reader<R, C>) -> Reader<R, D> {
		return { (m1 : Reader<R, A>) -> (Reader<R, B>) -> (Reader<R, C>) -> Reader<R, D> in { (m2 : Reader<R, B>) -> (Reader<R, C>) -> Reader<R, D> in { (m3 : Reader<R, C>) -> Reader<R, D> in m1 >>- { (x1 : A) in m2 >>- { (x2 : B) in m3 >>- { (x3 : C) in Reader<R, D>.pure(f(x1)(x2)(x3)) } } } } } }
	}
}

public func >>->> <R, A, B, C>(_ f : @escaping (A) -> Reader<R, B>, g : @escaping (B) -> Reader<R, C>) -> ((A) -> Reader<R, C>) {
	return { x in f(x) >>- g }
}

public func <<-<< <R, A, B, C>(g : @escaping (B) -> Reader<R, C>, f : @escaping (A) -> Reader<R, B>) -> ((A) -> Reader<R, C>) {
	return f >>->> g
}

// Can't get this to type check.
//public func sequence<R, A>(_ ms : [Reader<R, A>]) -> Reader<R, [A]> {
//    return ms.reduce(Reader.pure([]), combine: { n, m in
//        return n.bind { xs in
//            return  m.bind { x in
//                return Reader.pure(xs + [x])
//            }
//        }
//    })
//}
