//
//  ImArrayTests.swift
//  swiftz
//
//  Created by Terry Lewis II on 6/9/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import swiftz

class ImArrayTests: XCTestCase {	
	func testScanl() {
		let withArray = [1,2,3,4]
		let scanned = scanl(0, withArray, +)
		
		XCTAssert(scanned == [0,1,3,6,10], "Should be equal")
		XCTAssert(withArray == [1,2,3,4], "Should be equal(immutablility test)")
	}
	
	func testIntersperse() {
		let withArray = [1,2,3,4]
		let inter = intersperse(1, withArray)
		
		XCTAssert(inter == [1,1,2,1,3,1,4], "Should be equal")
		XCTAssert(withArray == [1,2,3,4], "Should be equal(immutablility test)")
		
		let single = [1]
		XCTAssert(intersperse(1, single) == [1], "Should be equal")
	}
	
	func testFind() {
		let withArray = [1,2,3,4]
		if let found = find(withArray, ==4) {
			XCTAssert(found == 4, "Should be found")
		}
	}
	
	func testSplitAt() {
		let withArray = [1,2,3,4]
		
		let tuple = splitAt(2,withArray)
		
		XCTAssert(tuple.0 == [1,2] && tuple.1 == [3,4], "Should be equal")
		
		XCTAssert(splitAt(0,withArray).0 == Array() && splitAt(0, withArray).1 == [1,2,3,4], "Should be equal")
		XCTAssert(withArray == [1,2,3,4], "Should be equal(immutablility test)")
	}
	
	func testAnd() {
		let withArray = [true, true, false, true]
		XCTAssertFalse(and(withArray), "Should be false")
	}
	
	func testOr() {
		let withArray = [true, true, false, true]
		XCTAssert(or(withArray), "Should be true")
	}
	
	func testAny() {
		let withArray = Array([1,4,5,7])
		XCTAssert(any(withArray, >4), "Should be false")
	}
	
	func testAll() {
		let array = [1,3,24,5]
		XCTAssert(all(array, <=24), "Should be true")
	}
	
	func testConcat() {
		let array = [[1,2,3],[4,5,6],[7],[8,9]]
		
		XCTAssert(concat(array) == [1,2,3,4,5,6,7,8,9], "Should be equal")
	}
	
	func testConcatMap() {
		let array = [1,2,3,4,5,6,7,8,9]
		
		XCTAssert(concatMap(array) { a in [a + 1] } == [2,3,4,5,6,7,8,9,10], "Should be equal")
	}
	
	
	func testIntercalate() {
		let result = intercalate([1,2,3], [[4,5],[6,7]])
		
		XCTAssert(result == [4,5,1,2,3,6,7], "Should be equal")
	}
	
	func testSpan() {
		let withArray = [1,2,3,4,1,2,3,4]
		
		let tuple = span(withArray, { a in a < 3 })
		XCTAssert(tuple.0 == [1,2] && tuple.1 == [3,4,1,2,3,4], "Should be equal")
	}
	
	func testGroup() {
		let array = [1,2,3,3,4,5,6,7,7,8,9,9,0]
		let result = group(array)
		
		XCTAssert(result == [[1],[2],[3,3],[4],[5],[6],[7,7],[8],[9,9],[0]], "Should be equal")
	}
	
	func testDropWhile() {
		let array = [1,2,3,4,5]
		
		XCTAssert(dropWhile(array, <=3) == [4,5], "Should be equal")
	}
	
	func testTakeWhile() {
		let array = [1,2,3,4,5]
		
		XCTAssert(takeWhile(array, <=3) == [1,2,3], "Should be equal")
	}
}
