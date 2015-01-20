//
//  ChanSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import swiftz

class ChanSpec : XCTestCase {
	func testConcurrentChan() {
		var chan: Chan<Int> = Chan()
		let ft = Future<Int>(exec: gcdExecutionContext, { usleep(1); chan.write(2); return 2 })
		XCTAssert(chan.read() == ft.result(), "simple read chan")
	}
}
