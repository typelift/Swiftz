//
//  MonoidSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

class MonoidSpec : XCTestCase {
	func testProperties() {
		property["sconcat works"] = forAll { (xs : ArrayOf<UInt>) in
			return sconcat(Min(2), (xs.getArray + [0]).map { Min($0) }).value() == 0
		}

		property["monoid sum works"] = forAll { (xs : ArrayOf<Int8>) in
			return mconcat(xs.getArray.map { Sum($0) }).value() == xs.getArray.reduce(0, combine: +)
		}

		property["monoid product works"] = forAll { (xs : ArrayOf<Int8>) in
			return mconcat(xs.getArray.map { Sum($0) }).value() == xs.getArray.reduce(1, combine: *)
		}
	}

	func testDither() {
		let v : Dither<Product<Int8>, Sum<Int16>> = Dither([Either.left(Product(2)), Either.left(Product(3)), Either.right(Sum(5)), Either.left(Product(7))])
		XCTAssert(v.fold(onLeft: { n in Sum(Int16(n.value())) }, onRight: identity).value() == 18, "Dither works")
	}
}
