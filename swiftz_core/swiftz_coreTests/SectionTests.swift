//
//  SectionTests.swift
//  swiftz_core
//
//  Created by Robert Widmann on 11/24/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import swiftz_core

class SectionTests: XCTestCase {
	func testShiftRightSections() {
		let s = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		let t = s.map({ x in x >> 2 })
		
		XCTAssertTrue(s.map(>>2) == t, "")
		
		let t2 = s.map({ x in 2 >> x })
		XCTAssertTrue(s.map(2>>) == t2, "")
	}
	
	func testShiftLeftSections() {
		let s = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		let t = s.map({ x in x << 2 })
		
		XCTAssertTrue(s.map(<<2) == t, "")
		
		let t2 = s.map({ x in 2 << x })
		XCTAssertTrue(s.map(2<<) == t2, "")
	}
	
	func testClosedIntervalSections() {
		let s = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		let t = s.map({ x in x...11 })
		
		XCTAssertTrue(s.map(...11) == t, "")
		
		let t2 = s.map({ x in 0...x })
		XCTAssertTrue(s.map(0...) == t2, "")
	}
	
	func testOpenIntervalSections() {
		let s = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		let t = s.map({ x in x..<11 })
		
		XCTAssertTrue(s.map(..<11) == t, "")
		
		let t2 = s.map({ x in 0..<x })
		XCTAssertTrue(s.map(0..<) == t2, "")
	}
	
	
	func testDivisionSections() {
		let s = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		let t = s.map({ x in x / 5 })
		
		XCTAssertTrue(s.map(/5) == t, "")
		
		let t2 = s.map({ x in 5 / x })
		XCTAssertTrue(s.map(5/) == t2, "")
	}
	
	func testRemainderSections() {
		let s = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		let t = s.map({ x in x % 5 })
		
		XCTAssertTrue(s.map(%5) == t, "")
		
		let t2 = s.map({ x in 5 % x })
		XCTAssertTrue(s.map(5%) == t2, "")
	}
	
	func testSubtractionSections() {
		let s = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]		
		let t = s.map({ x in 5 - x })
		
		XCTAssertTrue(s.map(5-) == t, "")
	}
	
	func testAdditionSections() {
		let s = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		let t = s.map({ x in x + 5 })
		
		XCTAssertTrue(s.map(+5) == t, "")
		
		let t2 = s.map({ x in 5 + x })
		XCTAssertTrue(s.map(5+) == t2, "")
	}
	
	func testMultiplicationSections() {
		let s = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		let t = s.map({ x in x * 5 })
		
		XCTAssertTrue(s.map(*5) == t, "")
		
		let t2 = s.map({ x in 5 * x })
		XCTAssertTrue(s.map(5*) == t2, "")
	}
	
	func testOverflowDivisionSections() {
		let s = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		let t = s.map({ x in x &/ 5 })
		
		XCTAssertTrue(s.map(&/5) == t, "")
		
		let t2 = s.map({ x in 5 &/ x })
		XCTAssertTrue(s.map(5&/) == t2, "")
	}
	
	func testOverflowRemainderSections() {
		let s = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		let t = s.map({ x in x &% 5 })
		
		XCTAssertTrue(s.map(&%5) == t, "")
		
		let t2 = s.map({ x in 5 &% x })
		XCTAssertTrue(s.map(5&%) == t2, "")
	}
	
	func testUnderflowSubtractionSections() {
		let s = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		let t = s.map({ x in x &- 5 })
		
		XCTAssertTrue(s.map(&-5) == t, "")
		
		let t2 = s.map({ x in 5 &- x })
		XCTAssertTrue(s.map(5&-) == t2, "")
	}
	
	func testOverflowAdditionSections() {
		let s = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		let t = s.map({ x in x &+ 5 })
		
		XCTAssertTrue(s.map(&+5) == t, "")
		
		let t2 = s.map({ x in 5 &+ x })
		XCTAssertTrue(s.map(5&+) == t2, "")
	}
	
	func testOverflowMultiplicationSections() {
		let s = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		let t = s.map({ x in x &* 5 })
		
		XCTAssertTrue(s.map(&*5) == t, "")
		
		let t2 = s.map({ x in 5 &* x })
		XCTAssertTrue(s.map(5&*) == t2, "")
	}

	func testXORSections() {
		let s = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		let t = s.map({ x in x ^ 5 })

		XCTAssertTrue(s.map(^5) == t, "")
		
		let t2 = s.map({ x in 5 ^ x })
		XCTAssertTrue(s.map(5^) == t2, "")
	}
	
	func testORSections() {
		let s = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		let t = s.map({ x in x | 5 })
		
		XCTAssertTrue(s.map(|5) == t, "")
		
		let t2 = s.map({ x in 5 | x })
		XCTAssertTrue(s.map(5|) == t2, "")
	}
	
	func testNilCoalescingSections() {
		let s : [Int?] = [.Some(5), nil, .Some(10), nil]
		let t = s.map({ x in x ?? 0 })
		
		XCTAssertTrue(s.map(??0) == t, "")
	}
	
	func testEqualitySections() {
		let s = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		let t = s.map({ x in x == 5 })
		
		XCTAssertTrue(s.map(==5) == t, "")
	}
	
	func testReferenceEqualitySections() {
		let x = Box()
		let y = Box()
		let z = Box()
		
		let s = [x, y, z]
		let t = s.map({ x in x === y })
		
		XCTAssertTrue(s.map(===y) == t, "")
	}
}
