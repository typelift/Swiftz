//
//  ArrayExtSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import swiftz

class ArrayExtSpec : XCTestCase {
	func testArrayExt() {
		let xsO: [Optional<Int>] = [Optional.Some(1), .Some(2), .None]
		let exO: [Int] = mapFlatten(xsO)

		XCTAssert(exO == [1, 2], "mapflatten option")

		let exJ = concat([[1, 2], [3, 4]])

		XCTAssert(exJ == [1, 2, 3, 4], "mapflatten option")

		XCTAssert(indexArray([1], 0) == 1, "index array 0")
		XCTAssert(indexArray([Int](), 0) == nil, "index array empty")
	}

	func testArray() {
		let xs = [1, 2, 3]
		let y = Optional<Int>.None
		let incedXs = (+1 <^> xs)

		XCTAssert(incedXs == [2, 3, 4], "array fmap")
		XCTAssert(xs == [1, 2, 3], "fmap isn't destructive")

		XCTAssert((.Some(+1) <*> .Some(1)) == 2, "array apply")

		func fs(x : Int) -> [Int] {
			return [x, x+1, x+2]
		}

		let rs = xs >>- fs

		XCTAssert(rs == [1, 2, 3, 2, 3, 4, 3, 4, 5], "array bind")

		XCTAssert(pure(1) == [1], "array pure")
	}

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
