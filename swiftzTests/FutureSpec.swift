//
//  FutureSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import swiftz

class FutureSpec : XCTestCase {
	func testConcurrentFuture() {
		var e: NSError?
		let x: Future<Int> = Future(exec: gcdExecutionContext, {
			usleep(1)
			return 4
		})
		XCTAssert(x.result() == x.result(), "future")
		XCTAssert(x.map({ $0.description }).result() == "4", "future map")
		XCTAssert(x.flatMap({ (x: Int) -> Future<Int> in
			return Future(exec: gcdExecutionContext, { usleep(1); return x + 1 })
		}).result() == 5, "future flatMap")

		//    let x: Future<Int> = Future(exec: gcdExecutionContext, {
		//      return NSString.stringWithContentsOfURL(NSURL.URLWithString("http://github.com"), encoding: 0, error: nil)
		//    })
		//    let x1 = (x.result().lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
		//    let x2 = (x.result().lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
		//    XCTAssert(x1 == x2)
	}
}
