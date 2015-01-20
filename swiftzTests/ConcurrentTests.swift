//
//  ConcurrentTests.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import swiftz

class ConcurrentTests: XCTestCase {		
	func testPerformanceExample() {
		// concurrent pi
		let term:(Chan<CDouble>, CDouble) -> Void = {(ch: Chan<CDouble>, k: CDouble) -> Void in
			ch <- (4 * pow(-1, k) / (2 * k + 1))
		}
		
		let pi:Int -> CDouble = {
			(n:Int) -> CDouble in
			let ch = Chan<CDouble>()
			for k in (0..<n) {
				Future<Void>(exec: gcdExecutionContext, { return term(ch, CDouble(k)) })
			}
			var f = 0.0
			for k in (0..<n) {
				f = f + ch.read()
			}
			return f
		}
		
		
		self.measureBlock() {
			pi(200)
			Void()
		}
	}
}
