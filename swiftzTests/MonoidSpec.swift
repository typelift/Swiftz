//
//  MonoidSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import swiftz

class MonoidSpec : XCTestCase {
	func testDataSemigroup() {
		let xs = [1, 2, 0, 3, 4]
		XCTAssert(sconcat(Min(), 2, xs) == 0, "sconcat works")
	}

	func testDataMonoid() {
		let xs: [Int8] = [1, 2, 0, 3, 4]
		XCTAssert(mconcat(Sum    <Int8, NInt8>(i: nint8), xs) == 10, "monoid sum works")
		XCTAssert(mconcat(Product<Int8, NInt8>(i: nint8), xs) == 0, "monoid product works")
	}
}
