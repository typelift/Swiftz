//
//  MaybeSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import swiftz

class MaybeSpec : XCTestCase {
	func testMaybe() {
		let x = Maybe.just(10)
		let y = Maybe.just(7)
		let z = Maybe<Int>.none()

		XCTAssertTrue(x == x, "")
		XCTAssertTrue(y == y, "")
		XCTAssertTrue(z == z, "")

		XCTAssertTrue(x != y, "")
		XCTAssertTrue(x != z)
		XCTAssertTrue(y != z, "")
	}

	func testMaybeFunctor() {
		let x = Maybe.just(2)
		let y = x.fmap({ $0 * 2 })
		XCTAssert(y == Maybe.just(4))

		let a = Maybe<Int>.none()
		let b = a.fmap({ $0 * 2 })
		XCTAssert(b == a);
	}

	func testMaybeApplicative() {
		let x = Maybe<Int>.pure(2)
		let fn = Maybe.just({ $0 * 2 })
		let y = x.ap(fn)

		let fno = Maybe<Int -> String>.none()
		let b = x.ap(fno)
		XCTAssert(b == Maybe.none());
	}
}
