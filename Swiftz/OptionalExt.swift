//
//  OptionalExt.swift
//  Swiftz
//
//  Created by Maxwell Swadling on 4/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

extension Optional {
	/// Case analysis for the Optional type.  Given a maybe, a default value in case it is None, and
	/// a function, maps the function over the value in the Maybe.
	public func maybe<B>(def : B, onSome : Wrapped -> B) -> B {
		switch self {
		case .None:
			return def
		case let .Some(x):
			return onSome(x)
		}
	}


	/// Given an Optional and a default value returns the value of the Optional when it is Some, else
	/// this function returns the default value.
	public func getOrElse(def : Wrapped) -> Wrapped {
		switch self {
		case .None:
			return def
		case let .Some(x):
			return x
		}
	}
	
	/// Case analysis for the Optional type to the Either type. Given a maybe, a default value in case it is None that maps to Either.Left, and
	/// if there is a value in the Maybe it maps to Either.Right.
	public func toEither<L>(`default` : L) -> Either<L, Wrapped> {
		switch self {
		case .None:
			return .Left(`default`)
		case .Some(let x):
			return .Right(x)
		}
	}
}

/// MARK: Instances

extension Optional : Functor {
	public typealias A = Wrapped
	public typealias B = Any
	public typealias FB = Optional<B>

	public func fmap<B>(f : Wrapped -> B) -> Optional<B> {
		return self.map(f)
	}
}

extension Optional /*: Pointed*/ {
	public static func pure(x : Wrapped) -> Optional<Wrapped> {
		return .Some(x)
	}
}

extension Optional : Applicative {
	public typealias FA = Optional<A>
	public typealias FAB = Optional<A -> B>

	public func ap<B>(f : Optional<A -> B>) -> Optional<B>	{
		return f <*> self
	}
}

extension Optional : ApplicativeOps {
	public typealias C = Any
	public typealias FC = Optional<C>
	public typealias D = Any
	public typealias FD = Optional<D>

	public static func liftA<B>(f : A -> B) -> Optional<A> -> Optional<B> {
		return { a in Optional<A -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(f : A -> B -> C) -> Optional<A> -> Optional<B> -> Optional<C> {
		return { a in { b in f <^> a <*> b  } }
	}

	public static func liftA3<B, C, D>(f : A -> B -> C -> D) -> Optional<A> -> Optional<B> -> Optional<C> -> Optional<D> {
		return { a in { b in { c in f <^> a <*> b <*> c } } }
	}
}

extension Optional : Monad {
	public func bind<B>(f : A -> Optional<B>) -> Optional<B> {
		return self >>- f
	}
}

extension Optional : MonadOps {
	public static func liftM<B>(f : A -> B) -> Optional<A> -> Optional<B> {
		return { m1 in m1 >>- { x1 in Optional<B>.pure(f(x1)) } }
	}

	public static func liftM2<B, C>(f : A -> B -> C) -> Optional<A> -> Optional<B> -> Optional<C> {
		return { m1 in { m2 in m1 >>- { x1 in m2 >>- { x2 in Optional<C>.pure(f(x1)(x2)) } } } }
	}

	public static func liftM3<B, C, D>(f : A -> B -> C -> D) -> Optional<A> -> Optional<B> -> Optional<C> -> Optional<D> {
		return { m1 in { m2 in { m3 in m1 >>- { x1 in m2 >>- { x2 in m3 >>- { x3 in Optional<D>.pure(f(x1)(x2)(x3)) } } } } } }
	}
}

public func >>->> <A, B, C>(f : A -> Optional<B>, g : B -> Optional<C>) -> (A -> Optional<C>) {
	return { x in f(x) >>- g }
}

public func <<-<< <A, B, C>(g : B -> Optional<C>, f : A -> Optional<B>) -> (A -> Optional<C>) {
	return f >>->> g
}

extension Optional : Foldable {
	public func foldr<B>(k : A -> B -> B, _ i : B) -> B {
		if let v = self {
			return k(v)(i)
		}
		return i
	}

	public func foldl<B>(k : B -> A -> B, _ i : B) -> B {
		if let v = self {
			return k(i)(v)
		}
		return i
	}

	public func foldMap<M : Monoid>(f : A -> M) -> M {
		return self.foldr(curry(<>) • f, M.mempty)
	}
}

extension Optional : SequenceType {
	public typealias Generator = GeneratorOfOne<Wrapped>

	public func generate() -> GeneratorOfOne<Wrapped> {
		return GeneratorOfOne(self)
	}
}

/// Forbidden by Swift 1.2; see ~( http://stackoverflow.com/a/29750368/945847 ))
/// Given one or more Optional values, returns the first Optional value that is not nil
/// when evaulated from left to right
// public func coalesce<T>(all : @autoclosure () -> T? ...) -> T? {
// 	for f : () -> T? in all {
// 		if let x = f() { return x }
// 	}
// 	return nil
// }

/// Forbidden by Swift 1.2; see ~( http://stackoverflow.com/a/29750368/945847 ))
/// Given one or more Optional values, returns the first Optional value that is not nil
/// and satisfies the approve function when evaulated from left to right
// public func coalesce<T>(approve : T -> Bool) -> (@autoclosure () -> T? ...) -> T? {
// 	return { all in
// 		for f : () -> T? in all {
// 			if let x = f() {
// 				if approve(x) { return x }
// 			}
// 		}
// 		return nil
// 	}
// }
