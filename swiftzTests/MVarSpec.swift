//
//  MVarSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import swiftz

class MVarSpec {
	func testConcurrentMVar() {
		var pingvar: MVar<String> = MVar()
		var pongvar: MVar<String> = MVar()
		var done: MVar<()> = MVar()

		let ping = Future<Void>(exec: gcdExecutionContext, { pingvar.put("hello"); XCTAssert(pongvar.take() == "max", "mvar read"); done.put(()) })
		let pong = Future<Void>(exec: gcdExecutionContext, { XCTAssert(pingvar.take() == "hello", "mvar read"); pongvar.put("max") })

		XCTAssert(done.take() == (), "mvar read finished")
		XCTAssert(pingvar.isEmpty() && pongvar.isEmpty(), "mvar empty")
	}
}
