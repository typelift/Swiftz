//
//  OptionalExt.swift
//  Swiftz
//
//  Created by Maxwell Swadling on 4/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

#if !XCODE_BUILD
	import Operadics
	import Swiftx
#endif

extension Optional {
	/// Case analysis for the Optional type.  Given a maybe, a default value in 
	/// case it is None, and a function, maps the function over the value in the Maybe.
	public func maybe<B>(_ def : B, onSome : (Wrapped) -> B) -> B {
		switch self {
		case .none:
			return def
		case let .some(x):
			return onSome(x)
		}
	}


	/// Given an Optional and a default value returns the value of the Optional 
	/// when it is Some, else this function returns the default value.
	public func getOrElse(_ def : Wrapped) -> Wrapped {
		switch self {
		case .none:
			return def
		case let .some(x):
			return x
		}
	}
	
	/// Case analysis for the Optional type to the Either type. Given a maybe, a
	/// default value in case it is None that maps to Either.Left, and if there
	/// is a value in the Maybe it maps to Either.Right.
	public func toEither<L>(_ def : L) -> Either<L, Wrapped> {
		switch self {
		case .none:
			return .Left(def)
		case .some(let x):
			return .Right(x)
		}
	}
}

/// MARK: Instances

extension Optional /*: Functor*/ {
	public typealias A = Wrapped
	public typealias B = Any
	public typealias FB = Optional<B>

	public func fmap<B>(_ f : (Wrapped) -> B) -> Optional<B> {
		return self.map(f)
	}
}

extension Optional /*: Pointed*/ {
	public static func pure(_ x : Wrapped) -> Optional<Wrapped> {
		return .some(x)
	}
}

extension Optional /*: Applicative*/ {
	public typealias FA = Optional<A>
	public typealias FAB = Optional<(A) -> B>

	public func ap<B>(_ f : Optional<(A) -> B>) -> Optional<B>	{
		return f <*> self
	}
}

extension Optional /*: Cartesian*/ {
	public typealias FTOP = Optional<()>
	public typealias FTAB = Optional<(A, B)>
	public typealias FTABC = Optional<(A, B, C)>
	public typealias FTABCD = Optional<(A, B, C, D)>
	
	public static var unit : Optional<()> { return .some(()) }
	public func product<B>(_ r : Optional<B>) -> Optional<(A, B)> {
		switch (self, r) {
		case let (.some(l), .some(r)):
			return .some((l, r))
		default:
			return .none
		}
	}
	
	public func product<B, C>(_ r : Optional<B>, _ s : Optional<C>) -> Optional<(A, B, C)> {
		switch (self, r, s) {
		case let (.some(l), .some(r), .some(s)):
			return .some((l, r, s))
		default:
			return .none
		}
	}
	
	public func product<B, C, D>(_ r : Optional<B>, _ s : Optional<C>, _ t : Optional<D>) -> Optional<(A, B, C, D)> {
		switch (self, r, s, t) {
		case let (.some(l), .some(r), .some(s), .some(t)):
			return .some((l, r, s, t))
		default:
			return .none
		}
	}
}

extension Optional /*: ApplicativeOps*/ {
	public typealias C = Any
	public typealias FC = Optional<C>
	public typealias D = Any
	public typealias FD = Optional<D>

	public static func liftA<B>(_ f : @escaping (A) -> B) -> (Optional<A>) -> Optional<B> {
		return { (a : Optional<A>) -> Optional<B> in Optional<(A) -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(_ f : @escaping (A) -> (B) -> C) -> (Optional<A>) -> (Optional<B>) -> Optional<C> {
		return { (a : Optional<A>) -> (Optional<B>) -> Optional<C> in { (b : Optional<B>) -> Optional<C> in f <^> a <*> b  } }
	}

	public static func liftA3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (Optional<A>) -> (Optional<B>) -> (Optional<C>) -> Optional<D> {
		return { (a : Optional<A>) -> (Optional<B>) -> (Optional<C>) -> Optional<D> in { (b : Optional<B>) -> (Optional<C>) -> Optional<D> in { (c : Optional<C>) -> Optional<D> in f <^> a <*> b <*> c } } }
	}
}

extension Optional /*: Monad*/ {
	public func bind<B>(_ f : (A) -> Optional<B>) -> Optional<B> {
		return self >>- f
	}
}

extension Optional /*: MonadOps*/ {
	public static func liftM<B>(_ f : @escaping (A) -> B) -> (Optional<A>) -> Optional<B> {
		return { (m1 : Optional<A>) -> Optional<B>  in m1 >>- { (x1 : A) in Optional<B>.pure(f(x1)) } }
	}

	public static func liftM2<B, C>(_ f : @escaping (A) -> (B) -> C) -> (Optional<A>) -> (Optional<B>) -> Optional<C> {
		return { (m1 : Optional<A>) -> (Optional<B>) -> Optional<C> in { (m2 : Optional<B>) -> Optional<C> in m1 >>- { (x1 : A) in m2 >>- { (x2 : B) in Optional<C>.pure(f(x1)(x2)) } } } }
	}

	public static func liftM3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (Optional<A>) -> (Optional<B>) -> (Optional<C>) -> Optional<D> {
		return { (m1 : Optional<A>) -> (Optional<B>) -> (Optional<C>) -> Optional<D> in { (m2 : Optional<B>) -> (Optional<C>) -> Optional<D> in { (m3 : Optional<C>) -> Optional<D> in m1 >>- { (x1 : A) in m2 >>- { (x2 : B) in m3 >>- { (x3 : C) in Optional<D>.pure(f(x1)(x2)(x3)) } } } } } }
	}
}

public func >>->> <A, B, C>(_ f : @escaping (A) -> Optional<B>, g : @escaping (B) -> Optional<C>) -> ((A) -> Optional<C>) {
	return { x in f(x) >>- g }
}

public func <<-<< <A, B, C>(g : @escaping (B) -> Optional<C>, f : @escaping (A) -> Optional<B>) -> ((A) -> Optional<C>) {
	return f >>->> g
}

extension Optional /*: Foldable*/ {
	public func foldr<B>(_ k : (A) -> (B) -> B, _ i : B) -> B {
		if let v = self {
			return k(v)(i)
		}
		return i
	}

	public func foldl<B>(_ k : (B) -> (A) -> B, _ i : B) -> B {
		if let v = self {
			return k(i)(v)
		}
		return i
	}

	public func foldMap<M : Monoid>(_ f : @escaping (A) -> M) -> M {
		return self.foldr(curry(<>) • f, M.mempty)
	}
}

extension Optional : Sequence {
	public typealias Iterator = IteratorOverOne<Wrapped>

	public func makeIterator() -> IteratorOverOne<Wrapped> {
		return IteratorOverOne(_elements: self)
	}
}

public func sequence<A>(_ ms : [Optional<A>]) -> Optional<[A]> {
	return ms.reduce(Optional<[A]>.pure([]), { n, m in
		return n.bind { xs in
			return m.bind { x in
				return Optional<[A]>.pure(xs + [x])
			}
		}
	})
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
