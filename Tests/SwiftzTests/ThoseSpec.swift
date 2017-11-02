//
//  ThoseSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015-2016 TypeLift. All rights reserved.
//

import XCTest
import Swiftz

#if !XCODE_BUILD
    import Operadics
    import Swiftx
#endif

class ThoseSpec : XCTestCase {
	func testThose() {
		let this = Those<String, Int>.This("String")
		let that = Those<String, Int>.That(1)
		let both = Those<String, Int>.These("String", 1)

		XCTAssert((this.isThis() && that.isThat() && both.isThese()) == true, "")
		XCTAssert(this.toTuple("String", 1) == that.toTuple("String", 1), "")

		XCTAssert(both.bimap(identity, identity) == both, "")
	}
    
    #if !(os(macOS) || os(iOS) || os(watchOS) || os(tvOS))
    static var allTests = testCase([
    ("testThose", testThose)
    ])
    #endif
}
