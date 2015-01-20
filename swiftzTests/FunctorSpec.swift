//
//  FunctorSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import swiftz

class FunctorSpec : XCTestCase {
	func testConst() {
		let s = "Goodbye!"
		let x : Const<String, String> = Const(s)
		XCTAssert(x.runConst == s)

		let b : Const<String, String> = x.fmap({ "I don't know why you say " + $0 })
		XCTAssert(b.runConst == s)
	}

	func testConstBifunctor() {
		let x : Const<String, String> = Const("Hello!")
		let y : Const<String, String>  = x.bimap({ "Why, " + $0 }, identity)
		XCTAssert(x.runConst != y.runConst)
	}

	func testTupleBifunctor() {
		let t : (Int, String) = (20, "Bottles of beer on the wall.")
		let y = TupleBF(t).bimap({ $0 - 1 }, identity)
		XCTAssert(y.0 != t.0)
		XCTAssert(y.1 == t.1)
	}
}
