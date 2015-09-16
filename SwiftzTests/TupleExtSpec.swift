//
//  TupleExtSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

class TupleExtSpec : XCTestCase {
	func testProperties() {
		property("fst behaves") <- forAll { (x : Int, y : Int) in
			return fst((x, y)) == x
		}

		property("snd behaves") <- forAll { (x : Int, y : Int) in
			return snd((x, y)) == y
		}
	}

	func testTupleEquality() {
		XCTAssert(("a",1,[1,2]) == ("a",1,[1,2]))
		XCTAssert(() == ())
		XCTAssert((0) == (0))
		XCTAssert((0,1) == (0,1))
		XCTAssert((0,1,2) == (0,1,2))
		XCTAssert((0,1,2,3) == (0,1,2,3))
		XCTAssert((0,1,2,3,4) == (0,1,2,3,4))
		XCTAssert((0,1,2,3,4,5) == (0,1,2,3,4,5))
		XCTAssertFalse(("b",1,[1,2]) == ("a",1,[1,2]))
		XCTAssertFalse((0) == (2))
		XCTAssertFalse((0,1) == (1,1))
		XCTAssertFalse((0,1,2) == (0,2,2))
		XCTAssertFalse((0,1,2,3) == (0,1,"a",3))
		XCTAssertFalse((0,1,2,3,4) == (0,1,2,[],4))
		XCTAssertFalse((0,1,2,3,4,5) == (0,1,2,3,0.4,5))
		XCTAssert(("b",1,[1,2]) != ("a",1,[1,2]))
		XCTAssert((0) != (2))
		XCTAssert((0,1) != (1,1))
		XCTAssert((0,1,2) != (0,2,2))
		XCTAssert((0,1,2,3) != (0,1,"a",3))
		XCTAssert((0,1,2,3,4) != (0,1,2,[],4))
		XCTAssert((0,1,2,3,4,5) != (0,1,2,3,0.4,5))
		XCTAssert(("a",1,[1,2]) == ("a",1,[1,2]))
		XCTAssertFalse(() != ())
		XCTAssertFalse((0) != (0))
		XCTAssertFalse((0,1) != (0,1))
		XCTAssertFalse((0,1,2) != (0,1,2))
		XCTAssertFalse((0,1,2,3) != (0,1,2,3))
		XCTAssertFalse((0,1,2,3,4) != (0,1,2,3,4))
		//  Only 6tuples and smaller currently supported.
		//  XCTAssert((0,1,2,3,4,5,6) == (0,1,2,3,4,5,6))
		//  Not currently possible as tuples cannot be generically made Equatable
		//  XCTAssert(((),(1),(2,2),(3,3,3),(4,4,4,4)) == ((),(1),(2,2),(3,3,3),(4,4,4,4)))
	}
}
