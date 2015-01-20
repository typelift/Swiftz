//
//  ThoseSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import swiftz

class ThoseSpec : XCTestCase {
	func testThose() {
		let this = Those<String, Int>.this("String")
		let that = Those<String, Int>.that(1)
		let both = Those<String, Int>.these("String", r: 1)

		XCTAssert((this.isThis() && that.isThat() && both.isThese()) == true, "")
		XCTAssert(this.toTuple("String", r: 1) == that.toTuple("String", r: 1), "")

		XCTAssert(both.bimap(identity, identity) == both, "")
	}
}
