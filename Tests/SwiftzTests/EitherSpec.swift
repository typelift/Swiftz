//
//  EitherSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015-2016 TypeLift. All rights reserved.
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
		return Gen.oneOf([
			A.arbitrary.map(Either.Left),
			B.arbitrary.map(Either.Right),
		]).map(EitherOf.init)
	}

	static func shrink(_ bl : EitherOf<A, B>) -> [EitherOf<A, B>] {
		return bl.getEither.either(onLeft: { x in
			return A.shrink(x).map(EitherOf.init • Either.Left)
		}, onRight: { y in
			return B.shrink(y).map(EitherOf.init • Either.Right)
		})
	}
}

class EitherSpec : XCTestCase {
	func divTwoEvenly(_ x: Int) -> Either<String, Int> {
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
			let y = e.getEither.bimap(identity, { $0 * 2 })
			if e.getEither.isLeft {
				return y == e.getEither
			} else {
				return y == ({ $0 * 2 } <^> e.getEither)
			}
		}

		property("sequence occurs in order") <- forAll { (xs : [String]) in
			let seq = sequence(xs.map(Either<NSError, String>.pure))
			return forAllNoShrink(Gen.pure(seq)) { ss in
				return ss.right! == xs
			}
		}
	}
}
