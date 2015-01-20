//
//  StringExtSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import swiftz

class StringExtSpec : XCTestCase {
	func testStringExt() {
		// some testing is done with properties in TestTests.swift
		XCTAssert(String.unlines("foo\nbar\n".lines()) == "foo\nbar\n", "lines / unlines a string")
	}
}
