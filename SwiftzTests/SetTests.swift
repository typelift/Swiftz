//
//  SetTests.swift
//  swiftz
//
//  Created by Terry Lewis II on 6/7/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import Swiftz

class SetTests: XCTestCase {
	func testInit() {
		let set = Set(array:[1,2,3,4,4,4,5,5,5])
		XCTAssert(set.count == 5, "Should be 5 items")
		
		let newSet = Set(arrayLiteral: 1,2,3,4,4,4,5,5,5)
		XCTAssert(set.count == 5, "Should be 5 items")
	}
	
	func testAdd() {
		let set = Set(array:[1,2,3,4,4,4,5,5,5])
		XCTAssert(set.add(5).count == 5, "Adding duplicate element changes nothing.")
		XCTAssert(set.add(6).count == 6, "Adding unique element changes count")
	}
	
	func testRemove() {
		let set = Set(array:[1,2,3,4,4,4,5,5,5])
		XCTAssert(set.remove(6).count == 5, "Removing unique element changes nothing.")
		XCTAssert(set.remove(5).count == 4, "Removing member element changes count")
	}
	
	func testEquality() {
		var set1 = Set(array:[1,2,3,4,4,4,5,5,5])
		var set2 = Set(array:[1,2,3,4,4,4,5,5,5])
		XCTAssert(set1 == set2, "Should be equal")
		
		var set3 = Set(array:[1,2,5,5,5])
		XCTAssert(set1 != set3, "Not equal")
	}
	
	func testIterator() {
		let set = Set(array:[1,2,3,4,4,4,5,5,5])
		var iterations = 0
		for x in set {
			iterations++
		}
		XCTAssert(iterations == set.count, "should be equal")
	}
	
	func testAny() {
		let set = Set(array:[1,2,3,4,4,4,5,5,5])
		for i in 0...3000 {
			var any = set.any()!
			XCTAssert(any >= 1 && any <= 5, "should always be in range")
		}
		let setEmpty = Set<Int>()
		XCTAssert(setEmpty.any() == nil, "should return nil on empty")
	}
	
	func testUnion() {
		let set = Set(array: [1,2,3,4,5,5,4,4,5,5])
		let otherSet = Set(arrayLiteral: 6,7,8,9,10,10,1000,5600)
		
		let newSet = set.union(otherSet)
		XCTAssert(newSet == Set(arrayLiteral: 1000, 5600, 6,7,8,9,10,1,2,3,4,5), "Should be equal")
		
	}
	
	func testFilterMap() {
		let set = Set(array: [1,2,3,4,5,5,4,4,5,5])
		let newSet = set.filter(>2).map(+1)
		XCTAssert(newSet == Set(array: [4,5,6]), "Should be equal")
	}
	
	func testPartition() {
		let set = Set(array: [1,2,3,4,5,5,4,4,5,5])
		let (s, n) = set.partition(>3)
		XCTAssert(s == [4, 5], "Expected partitioned elements to be 4 and 5")
		XCTAssert(n == [1, 2, 3], "Expected partitioned elements to be 1, 2, and 3")
	}
	
	func testReduce() {
		let set = Set<Int>(array: [1,2,3,4,5,5,4,4,5,5])
		XCTAssert(set.reduce({ $0 + $1 }, initial: 0) == 15, "Expected reduction to yield sum.")
	}
	
	func testIntersectsSet() {
		let set = Set(array: [1,2,3,4,5,5,4,4,5,5])
		XCTAssert(set.interectsSet(Set(arrayLiteral: 9,0,5)), "Should be true")
	}
	
	func testMember() {
		let set = Set(array: [1,2,3,4,5,5,4,4,5,5])
		let known = set.member(4)
		let unknown = set.member(45765)
		
		XCTAssert(known == Optional.Some(4), "Should be equal")
		XCTAssert(unknown == nil, "Should be nil")
	}
	
	func testMinus() {
		let set = Set(array: [1,2,3,4,5,5,4,4,5,5])
		let minus = set.minus(Set(arrayLiteral: 8,9,0,3,5))
		
		XCTAssert(minus == Set(arrayLiteral: 1,2,4), "Should be equal")
	}
	
	func testIntersect() {
		let set = Set(array: [1,2,3,4,5,5,4,4,5,5])
		let intersection = set.intersect(Set(arrayLiteral: 8,9,0,3,5))
		
		XCTAssert(intersection == Set(arrayLiteral: 3,5), "Should be equal")
	}
}
