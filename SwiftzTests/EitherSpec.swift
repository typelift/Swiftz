//
//  EitherSpec.swift
//  Swiftz
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

	static var arbitrary : Gen<EitherOf<A, B>> {
		return EitherOf.init <^> Gen.oneOf([
			Either.Left <^> A.arbitrary,
			Either.Right <^> B.arbitrary,
		])
	}

	static func shrink(bl : EitherOf<A, B>) -> [EitherOf<A, B>] {
		return bl.getEither.either(onLeft: { x in
			return A.shrink(x).map(EitherOf.init • Either.Left)
		}, onRight: { y in
			return B.shrink(y).map(EitherOf.init • Either.Right)
		})
	}
}

class EitherSpec : XCTestCase {
	func divTwoEvenly(x: Int) -> Either<String, Int> {
		if x % 2 == 0 {
			return Either.Left("\(x) was div by 2")
		} else {
			return Either.Right(x / 2)
		}
	}

	func testProperties() {
		property("divTwoEvenly") <- forAll { (x : Int) in
			let first : Either<String, Int> = self.divTwoEvenly(x)
			return first.either(onLeft: { s in
				return s == "\(x) was div by 2"
			}, onRight: { r in
				return r == (x / 2)
			})
		}

		property("fold returns its default on .Left") <- forAll { (e : EitherOf<String, Int>) in
			return e.getEither.isLeft ==> (e.getEither.fold(0, f: identity) == 0)
		}

		property("Either is a bifunctor") <- forAll { (e : EitherOf<String, Int>) in
			let y = e.getEither.bimap(identity, *2)
			if e.getEither.isLeft {
				return y == e.getEither
			} else {
				return y == ((*2) <^> e.getEither)
			}
		}

		// TODO: How in hell does this typecheck?
		// either
		XCTAssert(Either.Left("foo").either(onLeft: { l in l+"!" }, onRight: { r in r+1 }) == "foo!")
		XCTAssert(Either.Right(1).either(onLeft: { l in l+"!" }, onRight: { r in r+1 }) == 2)
	}
}
