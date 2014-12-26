//
//  ExtTests.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import swiftz

class ExtTests: XCTestCase {
	func testTupleExt() {
		XCTAssert(fst((1,2)) == 1, "tuple fst")
		XCTAssert(snd((1,2)) == 2, "tuple snd")
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
	
	func testArrayExt() {
		let xsO: [Optional<Int>] = [Optional.Some(1), .Some(2), .None]
		let exO: [Int] = mapFlatten(xsO)
		XCTAssert(exO == [1, 2], "mapflatten option")
		let exJ = concat([[1, 2], [3, 4]])
		XCTAssert(exJ == [1, 2, 3, 4], "mapflatten option")
		
		XCTAssert(indexArray([1], 0) == 1, "index array 0")
		XCTAssert(indexArray([Int](), 0) == nil, "index array empty")
	}
	
	func testStringExt() {
		// some testing is done with properties in TestTests.swift
		XCTAssert(String.unlines("foo\nbar\n".lines()) == "foo\nbar\n", "lines / unlines a string")
	}
	
	func testOptionalExt() {
		let x = Optional.Some(4)
		let y = Optional<Int>.None
		func f(i: Int) -> Optional<Int> {
			if i % 2 == 0 {
				return .Some(i / 2)
			} else {
				return .None
			}
		}
		XCTAssert((x >>- f) == Optional.Some(2), "optional flatMap")
		
		//    maybe(...)
		XCTAssert(getOrElse(Optional.None)(1) == 1, "optional getOrElse")
		
		XCTAssert(maybe(x)(0)(+1) == 5, "maybe for Some works")
		XCTAssert(maybe(y)(0)(+1) == 0, "maybe for None works")
	}
	
	func testDictionaryExt() {
		// TODO: test dictionary
	}
	
	func testDataNSDictionaryExt() {
		// TODO: test nsdictionary
	}
	
	func testNSArrayExt() {
		// TODO: test nsarray
	}
	
}
