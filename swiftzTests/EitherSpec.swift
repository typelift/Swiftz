//
//  EitherSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import swiftz

class EitherSpec : XCTestCase {
	func testEither() {
		func divTwoEvenly(x: Int) -> Either<String, Int> {
			if x % 2 == 0 {
				return Either.left("\(x) was div by 2")
			} else {
				return Either.right(x / 2)
			}
		}

		// either
		XCTAssert(Either.left("foo").either({ l in l+"!" }, { r in r+1 }) == "foo!")
		XCTAssert(Either.right(1).either({ l in l+"!" }, { r in r+1 }) == 2)

		// fold
		XCTAssert(Either.left("foo").fold(0, identity) == 0)
		XCTAssert(Either<String, Int>.right(10).fold(0, identity) == 10)

		// TODO: test <^>, <*> and pure

		let start = 17
		let first: Either<String, Int> = divTwoEvenly(start)
		let prettyPrinted: Either<String, String> = { $0.description } <^> first
		let snd = first >>- divTwoEvenly
		XCTAssert(prettyPrinted == Either.right("8"))
		XCTAssert(snd == Either.left("8 was div by 2"))
	}

	func testEitherBifunctor() {
		let x : Either<String, Int> = Either.right(2)
		let y = EitherBF(x).bimap(identity, { $0 * 2 })
		XCTAssert(y == Either.right(4))

		let a : Either<String, Int> = Either.left("Error!")
		let b = EitherBF(a).bimap(identity, { $0 * 2 })
		XCTAssert(b == a);
	}
}
