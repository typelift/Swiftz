//
//  HListSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import swiftz

class HListSpec : XCTestCase {
	func testHList() {
		typealias AList = HCons<Int, HCons<String, HNil>>
		let list: AList = HCons(h: 10, t: HCons(h: "banana", t: HNil()))
		XCTAssert(list.head == 10)
		XCTAssert(list.tail.head == "banana")
		XCTAssert(AList.length() == 2)
	}
}
