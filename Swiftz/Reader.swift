//
//  Reader.swift
//  Swiftz
//
//  Created by Matthew Purland on 11/25/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

/// A `Reader` monad with `R` for environment and `A` to represent the modified environment.
public struct Reader<R, A> {
    /// The function that modifies the environment
    public let reader : R -> A
    
    init(_ reader : R -> A) {
        self.reader = reader
    }
    
    /// Runs the reader and extracts the final value from it
    public func runReader(environment : R) -> A {
        return reader(environment)
    }
    
    /// Executes a computation in a modified environment
    public func local(f : R -> R) -> Reader<R, A> {
        return Reader(reader • f)
    }
}

public func runReader<R, A>(reader : Reader<R, A>) -> R -> A {
	return reader.runReader
}

/// Runs the reader and extracts the final value from it. This provides a global function for running a reader.
public func reader<R, A>(f : R -> A) -> Reader<R, A> {
	return Reader(f)
}

/// Retrieves the monad environment
public func ask<R>() -> Reader<R, R> {
	return Reader(identity)
}

/// Retrieves a function of the current environment
public func asks<R, A>(f : R -> A) -> Reader<R, A> {
    return Reader(f)
}

extension Reader : Functor {
    public typealias B = Any
    public typealias FB = Reader<R, B>
    
    public func fmap<B>(f : A -> B) -> Reader<R, B> {
		return Reader<R, B>(f • runReader)
    }
}

public func <^> <R, A, B>(f : A -> B, r : Reader<R, A>) -> Reader<R, B> {
    return r.fmap(f)
}

extension Reader : Pointed {
    public static func pure(a : A) -> Reader<R, A> {
        return Reader<R, A> { _ in a }
    }
}

extension Reader : Applicative {
    public typealias FAB = Reader<R, A -> B>
    
    public func ap(r : Reader<R, A -> B>) -> Reader<R, B> {
        return Reader<R, B>(runReader)
    }
}

public func <*> <R, A, B>(rfs : Reader<R, A -> B>, xs : Reader<R, A>) -> Reader<R, B>  {
    return Reader<R, B> { (environment : R) -> B in
        let a = xs.runReader(environment)
        let ab = rfs.runReader(environment)
        let b = ab(a)
        return b
    }
}

extension Reader : ApplicativeOps {
    public typealias C = Any
    public typealias FC = Reader<R, C>
    public typealias D = Any
    public typealias FD = Reader<R, D>
    
    public static func liftA(f : A -> B) -> Reader<R, A> -> Reader<R, B> {
        return { a in Reader<R, A -> B>.pure(f) <*> a }
    }
    
    public static func liftA2(f : A -> B -> C) -> Reader<R, A> -> Reader<R, B> -> Reader<R, C> {
        return { a in { b in f <^> a <*> b  } }
    }
    
    public static func liftA3(f : A -> B -> C -> D) -> Reader<R, A> -> Reader<R, B> -> Reader<R, C> -> Reader<R, D> {
        return { a in { b in { c in f <^> a <*> b <*> c } } }
    }
}

extension Reader : Monad {
    public func bind(f : A -> Reader<R, B>) -> Reader<R, B> {
        return self >>- f
    }
}

public func >>- <R, A, B>(r : Reader<R, A>, f : A -> Reader<R, B>) -> Reader<R, B> {
    return Reader<R, B> { (environment : R) -> B in
        let a = r.runReader(environment)
        let readerB = f(a)
		return readerB.runReader(environment)
    }
}

extension Reader : MonadOps {
    public static func liftM(f : A -> B) -> Reader<R, A> -> Reader<R, B> {
        return { m1 in m1 >>- { x1 in Reader<R, B>.pure(f(x1)) } }
    }
    
    public static func liftM2(f : A -> B -> C) -> Reader<R, A> -> Reader<R, B> -> Reader<R, C> {
        return { m1 in { m2 in m1 >>- { x1 in m2 >>- { x2 in Reader<R, C>.pure(f(x1)(x2)) } } } }
    }
    
    public static func liftM3(f : A -> B -> C -> D) -> Reader<R, A> -> Reader<R, B> -> Reader<R, C> -> Reader<R, D> {
        return { m1 in { m2 in { m3 in m1 >>- { x1 in m2 >>- { x2 in m3 >>- { x3 in Reader<R, D>.pure(f(x1)(x2)(x3)) } } } } } }
    }
}

public func >>->> <R, A, B, C>(f : A -> Reader<R, B>, g : B -> Reader<R, C>) -> (A -> Reader<R, C>) {
    return { x in f(x) >>- g }
}

public func <<-<< <R, A, B, C>(g : B -> Reader<R, C>, f : A -> Reader<R, B>) -> (A -> Reader<R, C>) {
    return f >>->> g
}
