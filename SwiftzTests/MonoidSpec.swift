//
//  MonoidSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz

class MonoidSpec : XCTestCase {
	func testDataSemigroup() {
		let xs = [1, 2, 0, 3, 4]
		XCTAssert(sconcat(Min(2), xs.map { Min($0) }).value() == 0, "sconcat works")
	}

	func testDataMonoid() {
		let xs : [Int8] = [1, 2, 0, 3, 4]
		XCTAssert(mconcat(xs.map { Sum($0) }).value() == 10, "monoid sum works")
		XCTAssert(mconcat(xs.map { Product($0) }).value() == 0, "monoid product works")
	}

	func testMonoidCoproduct() {
		let v : MonoidCoproduct<Product<Int8>, Sum<Int16>> = MonoidCoproduct([Either.left(Product(2)), Either.left(Product(3)), Either.right(Sum(5)), Either.left(Product(7))])
		XCTAssert(v.fold(onLeft: { n in Sum(Int16(n.value())) }, onRight: identity).value() == 18, "monoid coproduct works")
	}
}
