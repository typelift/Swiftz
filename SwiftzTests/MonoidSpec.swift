//
//  MonoidSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz

class MonoidSpec : XCTestCase {
	func testDataSemigroup() {
		let xs = [1, 2, 0, 3, 4]
		XCTAssert(sconcat(Min(2), xs.map { Min($0) }).value() == 0, "sconcat works")
	}

	func testDataMonoid() {
		let xs: [Int8] = [1, 2, 0, 3, 4]
		XCTAssert(mconcat(xs.map { Sum($0) }).value() == 10, "monoid sum works")
		XCTAssert(mconcat(xs.map { Product($0) }).value() == 0, "monoid product works")
	}
}
