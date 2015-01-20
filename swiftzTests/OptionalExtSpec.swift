//
//  OptionalSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import swiftz

class OptionalExtSpec : XCTestCase {
	func testOptional() {
		let x = Optional<Int>.Some(0)
		let y = Optional<Int>.None
		XCTAssert((+1 <^> x) == 1, "optional map some")
		XCTAssert((+1 <^> y) == .None, "optional map none")

		XCTAssert((.Some(+1) <*> .Some(1)) == 2, "apply some")

		XCTAssert((x >>- (pure • (+1))) == Optional<Int>.Some(1), "bind some")

		XCTAssert(pure(1) == .Some(1), "pure some")
	}

	func testOptionalExt() {
		let x = Optional.Some(4)
		let y = Optional<Int>.None

		XCTAssert((x >>- { i in
			if i % 2 == 0 {
				return .Some(i / 2)
			} else {
				return .None
			}
		}) == Optional.Some(2), "optional flatMap")

		//    maybe(...)
		XCTAssert(getOrElse(Optional.None)(1) == 1, "optional getOrElse")

		XCTAssert(maybe(x)(0)(+1) == 5, "maybe for Some works")
		XCTAssert(maybe(y)(0)(+1) == 0, "maybe for None works")
	}

}
