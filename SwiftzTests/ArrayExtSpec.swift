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
		property("mapFlatten is the same as removing the optionals from an array and forcing") <- forAll { (xs0 : ArrayOf<OptionalOf<Int>>) in
			return mapFlatten(xs0.getArray.map({ $0.getOptional })) == xs0.getArray.filter({ $0.getOptional != nil }).map({ $0.getOptional! })
		}

		property("indexArray is safe") <- forAll { (l : ArrayOf<Int>) in
			if l.getArray.isEmpty {
				return l.getArray.safeIndex(0) == nil
			}
			return l.getArray.safeIndex(0) != nil
		}

		property("Array fmap is the same as map") <- forAll { (xs : ArrayOf<Int>) in
			return (+1 <^> xs.getArray) == xs.getArray.map(+1)
		}

		property("Array pure give a singleton array") <- forAll { (x : Int) in
			return Array.pure(x) == [x]
		}

		property("Array bind works like a map then a concat") <- forAll { (xs : ArrayOf<Int>) in
			func fs(x : Int) -> [Int] {
				return [x, x+1, x+2]
			}

			return (xs.getArray >>- fs) == xs.getArray.map(fs).reduce([], combine: +)
		}

		property("Array obeys the Functor identity law") <- forAll { (x : ArrayOf<Int>) in
			return (x.getArray.map(identity)) == identity(x.getArray)
		}

		property("Array obeys the Functor composition law") <- forAll { (f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>, x : ArrayOf<Int>) in
			return ((f.getArrow • g.getArrow) <^> x.getArray) == (x.getArray.map(g.getArrow).map(f.getArrow))
		}

		property("Array obeys the Applicative identity law") <- forAll { (x : ArrayOf<Int>) in
			return (Array.pure(identity) <*> x.getArray) == x.getArray
		}

		reportProperty("Array obeys the first Applicative composition law") <- forAll { (fl : ArrayOf<ArrowOf<Int8, Int8>>, gl : ArrayOf<ArrowOf<Int8, Int8>>, x : ArrayOf<Int8>) in
			let f = fl.getArray.map({ $0.getArrow })
			let g = gl.getArray.map({ $0.getArrow })
			return (curry(•) <^> f <*> g <*> x.getArray) == (f <*> (g <*> x.getArray))
		}

		reportProperty("Array obeys the second Applicative composition law") <- forAll { (fl : ArrayOf<ArrowOf<Int8, Int8>>, gl : ArrayOf<ArrowOf<Int8, Int8>>, x : ArrayOf<Int8>) in
			let f = fl.getArray.map({ $0.getArrow })
			let g = gl.getArray.map({ $0.getArrow })
			return (Array.pure(curry(•)) <*> f <*> g <*> x.getArray) == (f <*> (g <*> x.getArray))
		}

		property("Array obeys the Monad left identity law") <- forAll { (a : Int, fa : ArrowOf<Int, ArrayOf<Int>>) in
			let f = { $0.getArray } • fa.getArrow
			return (Array.pure(a) >>- f) == f(a)
		}

		property("Array obeys the Monad right identity law") <- forAll { (m : ArrayOf<Int>) in
			return (m.getArray >>- Array.pure) == m.getArray
		}

		property("Array obeys the Monad associativity law") <- forAll { (fa : ArrowOf<Int, ArrayOf<Int>>, ga : ArrowOf<Int, ArrayOf<Int>>, m : ArrayOf<Int>) in
			let f = { $0.getArray } • fa.getArrow
			let g = { $0.getArray } • ga.getArrow
			return ((m.getArray >>- f) >>- g) == (m.getArray >>- { x in f(x) >>- g })
		}

		property("Array obeys the Monoidal left identity law") <- forAll { (x : ArrayOf<Int8>) in
			return (x.getArray <> []) == x.getArray
		}

		property("Array obeys the Monoidal right identity law") <- forAll { (x : ArrayOf<Int8>) in
			return ([] <> x.getArray) == x.getArray
		}

		property("scanl behaves") <- forAll { (withArray : ArrayOf<Int>) in
			let scanned = withArray.getArray.scanl(0, r: +)
			if withArray.getArray.isEmpty {
				return scanned == [0]
			}
			return scanned == [0] + [Int](withArray.getArray[1..<withArray.getArray.count]).scanl(0 + withArray.getArray.first!, r: +)
		}

		property("intersperse behaves") <- forAll { (withArray : ArrayOf<Int>) in
			let inter = withArray.getArray.intersperse(1)
			if withArray.getArray.isEmpty {
				return inter.isEmpty
			}
			return TestResult.succeeded // TODO: Test non-empty case
		}

		property("find either finds or nils") <- forAll { (withArray : ArrayOf<Int>) in
			if let found = withArray.getArray.find(==4) {
				return found == 4
			}
			return true
		}

		property("and behaves") <- forAll { (withArray : ArrayOf<Bool>) in
			if let _ = withArray.getArray.find(==false) {
				return !and(withArray.getArray)
			}
			return and(withArray.getArray)
		}

		property("or behaves") <- forAll { (withArray : ArrayOf<Bool>) in
			if let _ = withArray.getArray.find(==true) {
				return or(withArray.getArray)
			}
			return !or(withArray.getArray)
		}

		property("take behaves") <- forAll { (array : ArrayOf<Int>, limit : Positive<Int>) in
			return array.getArray.take(limit.getPositive).count <= limit.getPositive
		}

		property("drop behaves") <- forAll { (array : ArrayOf<Int>, limit : Positive<Int>) in
			return array.getArray.drop(limit.getPositive).count == max(0, array.getArray.count - limit.getPositive)
		}

		property("span behaves") <- forAll { (xs : ArrayOf<Int>, pred : ArrowOf<Int, Bool>) in
			let p = xs.getArray.span(pred.getArrow)
			let t = (xs.getArray.takeWhile(pred.getArrow), xs.getArray.dropWhile(pred.getArrow))
			return p.0 == t.0 && p.1 == t.1
		}

		property("intercalate behaves") <- forAll { (xs : ArrayOf<Int>, xxsa : ArrayOf<ArrayOf<Int>>) in
			let xxs = xxsa.getArray.map { $0.getArray }
			return intercalate(xs.getArray, nested: xxs) == concat(xxs.intersperse(xs.getArray))
		}

		property("group for Equatable things is the same as groupBy(==)") <- forAll { (xs : ArrayOf<Int>) in
			return group(xs.getArray) == xs.getArray.groupBy { $0 == $1 }
		}
	}


	func testAny() {
		let withArray = Array([1,4,5,7])
		XCTAssert(withArray.any(>4), "Should be false")
	}

	func testAll() {
		let array = [1,3,24,5]
		XCTAssert(array.all(<=24), "Should be true")
	}

	func testSplitAt() {
		let withArray = [1,2,3,4]

		let tuple = withArray.splitAt(2)
		XCTAssert(tuple.0 == [1,2] && tuple.1 == [3,4], "Should be equal")

		XCTAssert(withArray.splitAt(0).0 == Array() && withArray.splitAt(0).1 == [1,2,3,4], "Should be equal")
		XCTAssert(withArray.splitAt(1).0 == [1] && withArray.splitAt(1).1 == [2,3,4], "Should be equal")
		XCTAssert(withArray.splitAt(3).0 == [1,2,3] && withArray.splitAt(3).1 == [4], "Should be equal")
		XCTAssert(withArray.splitAt(4).0 == [1,2,3,4] && withArray.splitAt(4).1 == Array(), "Should be equal")
		XCTAssert(withArray.splitAt(5).0 == [1,2,3,4] && withArray.splitAt(5).1 == Array(), "Should be equal")

		XCTAssert(withArray == [1,2,3,4], "Should be equal(immutablility test)")
	}
}
