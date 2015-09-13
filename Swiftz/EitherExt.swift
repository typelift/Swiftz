//
//  EitherExt.swift
//  Swiftz
//
//  Created by Robert Widmann on 6/21/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

extension Either : Bifunctor {
	public typealias B = Any
	public typealias D = Any
	public typealias PAC = Either<L, R>
	public typealias PAD = Either<L, D>
	public typealias PBC = Either<B, R>
	public typealias PBD = Either<B, D>

	public func bimap<B, D>(f : L -> B, _ g : (R -> D)) -> Either<B, D> {
		switch self {
		case let .Left(bx):
			return Either<B, D>.Left(f(bx))
		case let .Right(bx):
			return Either<B, D>.Right(g(bx))
		}
	}

	public func leftMap<B>(f : L -> B) -> Either<B, R> {
		return self.bimap(f, identity)
	}

	public func rightMap(g : R -> D) -> Either<L, D> {
		return self.bimap(identity, g)
	}
}

extension Either : Functor {
	public typealias FB = Either<L, B>

	public func fmap<B>(f : R -> B) -> Either<L, B> {
		return f <^> self
	}
}

extension Either : Pointed {
	public typealias A = R

	public static func pure(r : R) -> Either<L, R> {
		return .Right(r)
	}
}

extension Either : Applicative {
	public typealias FAB = Either<L, R -> B>

	public func ap<B>(f : Either<L, R -> B>) -> Either<L, B> {
		return f <*> self
	}
}

extension Either : ApplicativeOps {
	public typealias C = Any
	public typealias FC = Either<L, C>
	public typealias FD = Either<L, D>

	public static func liftA<B>(f : A -> B) -> Either<L, A> -> Either<L, B> {
		return { a in Either<L, A -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(f : A -> B -> C) -> Either<L, A> -> Either<L, B> -> Either<L, C> {
		return { a in { b in f <^> a <*> b  } }
	}

	public static func liftA3<B, C, D>(f : A -> B -> C -> D) -> Either<L, A> -> Either<L, B> -> Either<L, C> -> Either<L, D> {
		return { a in { b in { c in f <^> a <*> b <*> c } } }
	}
}

extension Either : Monad {
	public func bind<B>(f : A -> Either<L, B>) -> Either<L, B> {
		return self >>- f
	}
}

extension Either : MonadOps {
	public static func liftM<B>(f : A -> B) -> Either<L, A> -> Either<L, B> {
		return { m1 in m1 >>- { x1 in Either<L, B>.pure(f(x1)) } }
	}

	public static func liftM2<B, C>(f : A -> B -> C) -> Either<L, A> -> Either<L, B> -> Either<L, C> {
		return { m1 in { m2 in m1 >>- { x1 in m2 >>- { x2 in Either<L, C>.pure(f(x1)(x2)) } } } }
	}

	public static func liftM3<B, C, D>(f : A -> B -> C -> D) -> Either<L, A> -> Either<L, B> -> Either<L, C> -> Either<L, D> {
		return { m1 in { m2 in { m3 in m1 >>- { x1 in m2 >>- { x2 in m3 >>- { x3 in Either<L, D>.pure(f(x1)(x2)(x3)) } } } } } }
	}
}

public func >>->> <L, A, B, C>(f : A -> Either<L, B>, g : B -> Either<L, C>) -> (A -> Either<L, C>) {
	return { x in f(x) >>- g }
}

public func <<-<< <L, A, B, C>(g : B -> Either<L, C>, f : A -> Either<L, B>) -> (A -> Either<L, C>) {
	return f >>->> g
}

extension Either : Foldable {
	public func foldr<B>(k : A -> B -> B, _ i : B) -> B {
		switch self {
		case .Left(_):
			return i
		case .Right(let y):
			return k(y)(i)
		}
	}

	public func foldl<B>(k : B -> A -> B, _ i : B) -> B {
		switch self {
		case .Left(_):
			return i
		case .Right(let y):
			return k(i)(y)
		}
	}

	public func foldMap<M : Monoid>(f : A -> M) -> M {
		switch self {
		case .Left(_):
			return M.mempty
		case .Right(let y):
			return f(y)
		}
	}
}
