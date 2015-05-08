//
//  ArrayExtSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

class ArrayExtSpec : XCTestCase {
	func testProperties() {
		property["mapFlatten is the same as removing the optionals from an array and forcing"] = forAll { (xs0 : ArrayOf<OptionalOf<Int>>) in
			return mapFlatten(xs0.getArray.map({ $0.getOptional })) == xs0.getArray.filter({ $0.getOptional != nil }).map({ $0.getOptional! })
		}

		property["concat works like Swift's append operator"] = forAll { (l : ArrayOf<Int>, r : ArrayOf<Int>) in
			return concat(l.getArray)(r.getArray) == l.getArray + r.getArray
		}

		property["indexArray is safe"] = forAll { (l : ArrayOf<Int>) in
			if l.getArray.isEmpty {
				return indexArray(l.getArray, 0) == nil
			}
			return indexArray(l.getArray, 0) != nil
		}

		property["array fmap is the same as map"] = forAll { (xs : ArrayOf<Int>) in
			return (+1 <^> xs.getArray) == xs.getArray.map(+1)
		}

		property["array pure give a singleton array"] = forAll { (x : Int) in
			return pure(x) == [x]
		}

		property["array bind works like a map then a concat"] = forAll { (xs : ArrayOf<Int>) in
			func fs(x : Int) -> [Int] {
				return [x, x+1, x+2]
			}

			return (xs.getArray >>- fs) == xs.getArray.map(fs).reduce([], combine: +)
		}

		property["scanl behaves"] = forAll { (withArray : ArrayOf<Int>) in
			let scanned = scanl(0, withArray.getArray, +)
			let check = Array(SequenceOf(Zip2(withArray.getArray + [0], [0] + withArray.getArray)))
			return scanned == ([0] + check.map(+))
		}

		property["intersperse behaves"] = forAll { (withArray : ArrayOf<Int>) in
			let inter = intersperse(1, withArray.getArray)
			if withArray.getArray.isEmpty {
				return inter.isEmpty
			}
			return succeeded() // TODO: Test non-empty case
		}

		property["find either finds or nils"] = forAll { (withArray : ArrayOf<Int>) in
			if let found = find(withArray.getArray, ==4) {
				return found == 4
			}
			return true
		}

		property["and behaves"] = forAll { (withArray : ArrayOf<Bool>) in
			if let found = find(withArray.getArray, ==false) {
				return !and(withArray.getArray)
			}
			return and(withArray.getArray)
		}

		property["or behaves"] = forAll { (withArray : ArrayOf<Bool>) in
			if let found = find(withArray.getArray, ==true) {
				return or(withArray.getArray)
			}
			return !or(withArray.getArray)
		}

		property["take behaves"] = forAll { (array : ArrayOf<Int>, limit : Int) in
			return take(limit, from: array.getArray).count <= limit
		}

		property["drop behaves"] = forAll { (array : ArrayOf<Int>, limit : Int) in
			return drop(limit, from: array.getArray).count == max(0, array.getArray.count - limit)
		}
	}

	func testDropWhile() {
		let array = [1,2,3,4,5]

		XCTAssert(dropWhile(array, <=3) == [4,5], "Should be equal")
	}

	func testTakeWhile() {
		let array = [1,2,3,4,5]

		XCTAssert(takeWhile(array, <=3) == [1,2,3], "Should be equal")
	}

	func testAny() {
		let withArray = Array([1,4,5,7])
		XCTAssert(any(withArray, >4), "Should be false")
	}

	func testAll() {
		let array = [1,3,24,5]
		XCTAssert(all(array, <=24), "Should be true")
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

	func testSplitAt() {
		let withArray = [1,2,3,4]

		let tuple = splitAt(2,withArray)
		XCTAssert(tuple.0 == [1,2] && tuple.1 == [3,4], "Should be equal")

		XCTAssert(splitAt(0,withArray).0 == Array() && splitAt(0, withArray).1 == [1,2,3,4], "Should be equal")
		XCTAssert(splitAt(1,withArray).0 == [1] && splitAt(1, withArray).1 == [2,3,4], "Should be equal")
		XCTAssert(splitAt(3,withArray).0 == [1,2,3] && splitAt(3, withArray).1 == [4], "Should be equal")
		XCTAssert(splitAt(4,withArray).0 == [1,2,3,4] && splitAt(4, withArray).1 == Array(), "Should be equal")
		XCTAssert(splitAt(5,withArray).0 == [1,2,3,4] && splitAt(5, withArray).1 == Array(), "Should be equal")

		XCTAssert(withArray == [1,2,3,4], "Should be equal(immutablility test)")
	}
}
