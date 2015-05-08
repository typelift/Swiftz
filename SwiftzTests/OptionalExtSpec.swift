//
//  OptionalSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

class OptionalExtSpec : XCTestCase {
	func testProperties() {
		property["optional map behaves"] = forAll { (x : OptionalOf<Int>) in
			if let r = (+1 <^> x.getOptional) {
				return r == (x.getOptional! + 1)
			}
			return succeeded()
		}

		property["optional ap behaves"] = forAll { (x : OptionalOf<Int>) in
			if let r = (.Some(+1) <*> x.getOptional) {
				return r == (x.getOptional! + 1)
			}
			return succeeded()
		}

		property["optional bind behaves"] = forAll { (x : OptionalOf<Int>) in
			if let r = (x.getOptional  >>- (pure • (+1))) {
				return r == (x.getOptional! + 1)
			}
			return succeeded()
		}

		property["pure creates a .Some"] = forAll { (x : Int) in
			return pure(x) == .Some(x)
		}

		property["getOrElse behaves"] = forAll { (x : OptionalOf<Int>) in
			if let y = x.getOptional {
				return getOrElse(x.getOptional)(1) == y
			}
			return getOrElse(x.getOptional)(1) == 1
		}

		property["case analysis for Optionals behaves"] = forAll { (x : OptionalOf<Int>) in
			if let y = x.getOptional {
				return maybe(x.getOptional)(0)(+1) == (y + 1)
			}
			return maybe(x.getOptional)(0)(+1) == 0
		}
	}

	func testOptionalExt() {
		let x = Optional.Some(4)
		let y = Optional<Int>.None

		XCTAssert((x >>- { i in
			if i % 2 == 0 {
				return .Some(i / 2)
			} else {
				return .None
			}
		}) == Optional.Some(2), "optional flatMap")

		/// Forbidden by Swift 1.2; see ~( http://stackoverflow.com/a/29750368/945847 ))
		// XCTAssert(coalesce(x, y) == 4, "coalesce some first")
		// XCTAssert(coalesce(y, x) == 4, "coalesce some second")
		// XCTAssert(coalesce({ n in n > 4 })(y, x) == nil, "filter coalesce")

	}

}
