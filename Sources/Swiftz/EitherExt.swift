//
//  EitherExt.swift
//  Swiftz
//
//  Created by Robert Widmann on 6/21/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

#if !XCODE_BUILD
	import Operadics
	import Swiftx
#endif

extension Either /*: Bifunctor*/ {
	public typealias B = Any
	public typealias D = Any
	public typealias PAC = Either<L, R>
	public typealias PAD = Either<L, D>
	public typealias PBC = Either<B, R>
	public typealias PBD = Either<B, D>

	public func bimap<B, D>(_ f : (L) -> B, _ g : ((R) -> D)) -> Either<B, D> {
		switch self {
		case let .Left(bx):
			return Either<B, D>.Left(f(bx))
		case let .Right(bx):
			return Either<B, D>.Right(g(bx))
		}
	}

	public func leftMap<B>(_ f : @escaping (L) -> B) -> Either<B, R> {
		return self.bimap(f, identity)
	}

	public func rightMap(_ g : @escaping (R) -> D) -> Either<L, D> {
		return self.bimap(identity, g)
	}
}

extension Either /*: Functor*/ {
	public typealias FB = Either<L, B>

	public func fmap<B>(_ f : (R) -> B) -> Either<L, B> {
		return f <^> self
	}
}

extension Either /*: Pointed*/ {
	public typealias A = R

	public static func pure(_ r : R) -> Either<L, R> {
		return .Right(r)
	}
}

extension Either /*: Applicative*/ {
	public typealias FAB = Either<L, (R) -> B>

	public func ap<B>(_ f : Either<L, (R) -> B>) -> Either<L, B> {
		return f <*> self
	}
}

extension Either /*: Cartesian*/ {
	public typealias FTOP = Either<L, ()>
	public typealias FTAB = Either<L, (A, B)>
	public typealias FTABC = Either<L, (A, B, C)>
	public typealias FTABCD = Either<L, (A, B, C, D)>

	public static var unit : Either<L, ()> { return .Right(()) }
	public func product<B>(_ r : Either<L, B>) -> Either<L, (A, B)> {
		switch self {
		case let .Left(c):
			return .Left(c)
		case let .Right(d):
			switch r {
			case let .Left(e):
				return .Left(e)
			case let .Right(f):
				return .Right((d, f))
			}
		}
	}
	
	public func product<B, C>(_ r : Either<L, B>, _ s : Either<L, C>) -> Either<L, (A, B, C)> {
		switch self {
		case let .Left(c):
			return .Left(c)
		case let .Right(d):
			switch r {
			case let .Left(e):
				return .Left(e)
			case let .Right(f):
				switch s {
				case let .Left(g):
					return .Left(g)
				case let .Right(h):
					return .Right((d, f, h))
				}
			}
		}
	}
	
	public func product<B, C, D>(_ r : Either<L, B>, _ s : Either<L, C>, _ t : Either<L, D>) -> Either<L, (A, B, C, D)> {
		switch self {
		case let .Left(c):
			return .Left(c)
		case let .Right(d):
			switch r {
			case let .Left(e):
				return .Left(e)
			case let .Right(f):
				switch s {
				case let .Left(g):
					return .Left(g)
				case let .Right(h):
					switch t {
					case let .Left(i):
						return .Left(i)
					case let .Right(j):
						return .Right((d, f, h, j))
					}
				}
			}
		}
	}
}

extension Either /*: ApplicativeOps*/ {
	public typealias C = Any
	public typealias FC = Either<L, C>
	public typealias FD = Either<L, D>

	public static func liftA<B>(_ f : @escaping (A) -> B) -> (Either<L, A>) -> Either<L, B> {
		return { (a :  Either<L, A>) -> Either<L, B> in Either<L, (A) -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(_ f : @escaping (A) -> (B) -> C) -> (Either<L, A>) -> (Either<L, B>) -> Either<L, C> {
		return { (a : Either<L, A>) -> (Either<L, B>) -> Either<L, C> in { (b : Either<L, B>) -> Either<L, C> in f <^> a <*> b  } }
	}

	public static func liftA3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (Either<L, A>) -> (Either<L, B>) -> (Either<L, C>) -> Either<L, D> {
		return { (a : Either<L, A>) -> (Either<L, B>) -> (Either<L, C>) -> Either<L, D> in { (b : Either<L, B>) -> (Either<L, C>) -> Either<L, D> in { (c : Either<L, C>) -> Either<L, D> in f <^> a <*> b <*> c } } }
	}
}

extension Either /*: Monad*/ {
	public func bind<B>(_ f : (A) -> Either<L, B>) -> Either<L, B> {
		return self >>- f
	}
}

extension Either /*: MonadOps*/ {
	public static func liftM<B>(_ f : @escaping (A) -> B) -> (Either<L, A>) -> Either<L, B> {
		return { (m1 : Either<L, A>) -> Either<L, B> in m1 >>- { (x1 : A) -> Either<L, B> in Either<L, B>.pure(f(x1)) } }
	}

	public static func liftM2<B, C>(_ f : @escaping (A) -> (B) -> C) -> (Either<L, A>) -> (Either<L, B>) -> Either<L, C> {
		return { (m1 : Either<L, A>) -> (Either<L, B>) -> Either<L, C> in { (m2 :  Either<L, B>) -> Either<L, C> in m1 >>- { (x1 : A) in m2 >>- { (x2 : B) in Either<L, C>.pure(f(x1)(x2)) } } } }
	}

	public static func liftM3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (Either<L, A>) -> (Either<L, B>) -> (Either<L, C>) -> Either<L, D> {
		return { (m1 : Either<L, A>) -> (Either<L, B>) -> (Either<L, C>) -> Either<L, D> in { (m2 : Either<L, B>) -> (Either<L, C>) -> Either<L, D> in { (m3 : Either<L, C>) -> Either<L, D> in m1 >>- { (x1 : A) in m2 >>- { (x2 : B) in m3 >>- { (x3 : C) in Either<L, D>.pure(f(x1)(x2)(x3)) } } } } } }
	}
}

public func >>->> <L, A, B, C>(_ f : @escaping (A) -> Either<L, B>, g : @escaping (B) -> Either<L, C>) -> ((A) -> Either<L, C>) {
	return { x in f(x) >>- g }
}

public func <<-<< <L, A, B, C>(g : @escaping (B) -> Either<L, C>, f : @escaping (A) -> Either<L, B>) -> ((A) -> Either<L, C>) {
	return f >>->> g
}

extension Either /*: Foldable*/ {
	public func foldr<B>(k : (A) -> (B) -> B, _ i : B) -> B {
		switch self {
		case .Left(_):
			return i
		case .Right(let y):
			return k(y)(i)
		}
	}

	public func foldl<B>(k : (B) -> (A) -> B, _ i : B) -> B {
		switch self {
		case .Left(_):
			return i
		case .Right(let y):
			return k(i)(y)
		}
	}

	public func foldMap<M : Monoid>(_ f : (A) -> M) -> M {
		switch self {
		case .Left(_):
			return M.mempty
		case .Right(let y):
			return f(y)
		}
	}
}

public func sequence<L, R>(_ ms : [Either<L, R>]) -> Either<L, [R]> {
	return ms.reduce(Either<L, [R]>.pure([]), { n, m in
		return n.bind { xs in
			return m.bind { x in
				return Either<L, [R]>.pure(xs + [x])
			}
		}
	})
}
