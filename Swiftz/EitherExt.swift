//
//  EitherExt.swift
//  Swiftz
//
//  Created by Robert Widmann on 6/21/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

extension Either : Bifunctor {
	typealias B = Any
	typealias D = Any
	typealias PAC = Either<L, R>
	typealias PAD = Either<L, D>
	typealias PBC = Either<B, R>
	typealias PBD = Either<B, D>

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

	public func rightMap<D>(g : R -> D) -> Either<L, D> {
		return self.bimap(identity, g)
	}
}

extension Either : Functor {
	typealias FB = Either<L, B>

	public func fmap<B>(f : R -> B) -> Either<L, B> {
		return f <^> self
	}
}

extension Either : Pointed {
	typealias A = R

	public static func pure(r : R) -> Either<L, R> {
		return Either.Right(r)
	}
}

extension Either : Applicative {
	typealias FAB = Either<L, R -> B>

	public func ap<B>(f : Either<L, R -> B>) -> Either<L, B> {
		return f <*> self
	}
}

extension Either : Monad {
	public func bind<B>(f : A -> Either<L, B>) -> Either<L, B> {
		return self >>- f
	}
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
			return M.mzero
		case .Right(let y):
			return f(y)
		}
	}
}
