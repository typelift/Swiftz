//
//  EitherSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

struct EitherOf<A : Arbitrary, B : Arbitrary> : Arbitrary {
	let getEither : Either<A, B>

	init(_ either : Either<A, B>) {
		self.getEither = either
	}

	var description : String {
		return "\(self.getEither)"
	}

	private static func create(either : Either<A, B>) -> EitherOf<A, B> {
		return EitherOf(either)
	}

	static func arbitrary() -> Gen<EitherOf<A, B>> {
		return oneOf([ liftM(Either.left)(m1: A.arbitrary()), liftM(Either.right)(m1: B.arbitrary()) ]).fmap(EitherOf.create)
	}

	static func shrink(bl : EitherOf<A, B>) -> [EitherOf<A, B>] {
		return bl.getEither.either(onLeft: { x in
			return A.shrink(x).map(Either.left).map(EitherOf.create)
		}, onRight: { y in
			return B.shrink(y).map(Either.right).map(EitherOf.create)
		})
	}
}

class EitherSpec : XCTestCase {
	func divTwoEvenly(x: Int) -> Either<String, Int> {
		if x % 2 == 0 {
			return Either.left("\(x) was div by 2")
		} else {
			return Either.right(x / 2)
		}
	}

	func testProperties() {
		property["divTwoEvenly"] = forAll { (x : Int) in
			let first : Either<String, Int> = self.divTwoEvenly(x)
			return first.either(onLeft: { s in
				return s == "\(x) was div by 2"
			}, onRight: { r in
				return r == (x / 2)
			})
		}

		property["fold returns its default on .Left"] = forAll { (e : EitherOf<String, Int>) in
			if e.getEither.isLeft() {
				return e.getEither.fold(0, f: identity) == 0
			} else {
				return true // discard
			}
		}

		property["Either is a bifunctor"] = forAll { (e : EitherOf<String, Int>) in
			let y = EitherBF(e.getEither).bimap(identity, *2)
			if e.getEither.isLeft() {
				return y == e.getEither
			} else {
				return y == (*2) <^> e.getEither
			}
		}

		// TODO: How in hell does this typecheck?
		// either
		XCTAssert(Either.left("foo").either(onLeft: { l in l+"!" }, onRight: { r in r+1 }) == "foo!")
		XCTAssert(Either.right(1).either(onLeft: { l in l+"!" }, onRight: { r in r+1 }) == 2)
	}
}
