//
//  ListSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import swiftz

class ListSpec : XCTestCase {
	func testList() {
		let xs: List<(Int, String)> = [(1, "one"), (2, "two"), (3, "three")]
		let one: (Int, String) = xs.find({ (tp: (Int, String)) -> Bool in return (tp.0 == 1) })!
		XCTAssert(one.0 == 1 && one.1 == "one")

		let re: String? = xs.lookup(identity, key: 1)
		XCTAssert(re! == "one")

		self.measureBlock() {
			var lst: List<Int> = List()
			for x : Int in (0..<2600) {
				lst = List(x, lst)
			}
			XCTAssert(lst.length() == 2600)
		}

		let nats = List.iterate(+1, initial: 0)
		XCTAssertTrue(nats[0] == 0)
		XCTAssertTrue(nats[1] == 1)
		XCTAssertTrue(nats[2] == 2)

		let finite : List<UInt> = [1, 2, 3, 4, 5]
		let cycle = finite.cycle()
		for i : UInt in (0...100) {
			XCTAssertTrue(cycle[i] == finite[(i % 5)])
		}

		for i in finite {
			XCTAssertTrue(finite[i - 1] == i)
		}
	}
	
	func testListCombinators() {
		let t : List<Int> = [1, 2, 3]
		let u : List<Int> = [4, 5, 6]
		XCTAssert(t + u == [1, 2, 3, 4, 5, 6], "")

		let l : List<Int> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		XCTAssert(!l.isEmpty(), "")

		XCTAssert(l.map(+1) == [2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "")

		XCTAssert(l.concatMap({ List<Int>.replicate(2, value: $0) }) == [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10], "")
		XCTAssert(l.filter((==0) • (%2)) == [2, 4, 6, 8, 10], "")
		XCTAssert(l.reduce(curry(+), initial: 0) == 55, "")

		XCTAssert(u.scanl(curry(+), initial: 0) == [0, 4, 9, 15], "")
		XCTAssert(u.scanl1(curry(+)) == [4, 9, 15], "")
		XCTAssert(l.take(5) == [1, 2, 3, 4, 5], "")
		XCTAssert(l.drop(5) == [6, 7, 8, 9, 10], "")
	}

	func testListFunctor() {
		let x : List<Int> = [1, 2, 3]
		let y = x.fmap({ Double($0 * 2) })
		XCTAssert(y == [2.0, 4.0, 6.0])
	}

	func testNonEmptyListFunctor() {
		let x : NonEmptyList<Int> = [1, 2, 3]
		let y = x.fmap({ Double($0 * 2) })
		XCTAssert(y == [2.0, 4.0, 6.0])
	}
}
