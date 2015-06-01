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

		property["Array fmap is the same as map"] = forAll { (xs : ArrayOf<Int>) in
			return (+1 <^> xs.getArray) == xs.getArray.map(+1)
		}

		property["Array pure give a singleton array"] = forAll { (x : Int) in
			return pure(x) == [x]
		}

		property["Array bind works like a map then a concat"] = forAll { (xs : ArrayOf<Int>) in
			func fs(x : Int) -> [Int] {
				return [x, x+1, x+2]
			}

			return (xs.getArray >>- fs) == xs.getArray.map(fs).reduce([], combine: +)
		}

		property["Array obeys the Functor identity law"] = forAll { (x : ArrayOf<Int>) in
			return (x.getArray.map(identity)) == identity(x.getArray)
		}

		property["Array obeys the Functor composition law"] = forAll { (f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>, x : ArrayOf<Int>) in
			return ((f.getArrow • g.getArrow) <^> x.getArray) == (x.getArray.map(g.getArrow).map(f.getArrow))
		}

		property["Array obeys the Applicative identity law"] = forAll { (x : ArrayOf<Int>) in
			return (pure(identity) <*> x.getArray) == x.getArray
		}

		reportProperty["Array obeys the first Applicative composition law"] = forAll { (fl : ArrayOf<ArrowOf<Int8, Int8>>, gl : ArrayOf<ArrowOf<Int8, Int8>>, x : ArrayOf<Int8>) in
			let f = fl.getArray.map({ $0.getArrow })
			let g = gl.getArray.map({ $0.getArrow })
			return (curry(•) <^> f <*> g <*> x.getArray) == (f <*> (g <*> x.getArray))
		}

		reportProperty["Array obeys the second Applicative composition law"] = forAll { (fl : ArrayOf<ArrowOf<Int8, Int8>>, gl : ArrayOf<ArrowOf<Int8, Int8>>, x : ArrayOf<Int8>) in
			let f = fl.getArray.map({ $0.getArrow })
			let g = gl.getArray.map({ $0.getArrow })
			return (pure(curry(•)) <*> f <*> g <*> x.getArray) == (f <*> (g <*> x.getArray))
		}

		property["Array obeys the Monad left identity law"] = forAll { (a : Int, fa : ArrowOf<Int, ArrayOf<Int>>) in
			let f = { $0.getArray } • fa.getArrow
			return (pure(a) >>- f) == f(a)
		}

		property["Array obeys the Monad right identity law"] = forAll { (m : ArrayOf<Int>) in
			return (m.getArray >>- pure) == m.getArray
		}

		property["Array obeys the Monad associativity law"] = forAll { (fa : ArrowOf<Int, ArrayOf<Int>>, ga : ArrowOf<Int, ArrayOf<Int>>, m : ArrayOf<Int>) in
			let f = { $0.getArray } • fa.getArrow
			let g = { $0.getArray } • ga.getArrow
			return ((m.getArray >>- f) >>- g) == (m.getArray >>- { x in f(x) >>- g })
		}

		property["scanl behaves"] = forAll { (withArray : ArrayOf<Int>) in
			let scanned = scanl(0, withArray.getArray, +)
			if withArray.getArray.isEmpty {
				return scanned == [0]
			}
			return scanned == [0] + scanl(0 + withArray.getArray.first!, [Int](withArray.getArray[1..<withArray.getArray.count]), +)
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

		property["take behaves"] = forAll { (array : ArrayOf<Int>, limit : Positive<Int>) in
			return take(limit.getPositive, from: array.getArray).count <= limit.getPositive
		}

		property["drop behaves"] = forAll { (array : ArrayOf<Int>, limit : Positive<Int>) in
			return drop(limit.getPositive, from: array.getArray).count == max(0, array.getArray.count - limit.getPositive)
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
