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
		property["Sum obeys left identity"] = forAll { (i : Int) in
			return (Sum.mzero <> Sum(i)).value() == i
		}

		property["Sum obeys right identity"] = forAll { (i : Int) in
			return (Sum(i) <> Sum.mzero).value() == i
		}

		property["Product obeys left identity"] = forAll { (i : Int) in
			return (Product.mzero <> Product(i)).value() == i
		}

		property["Product obeys right identity"] = forAll { (i : Int) in
			return (Product(i) <> Product.mzero).value() == i
		}

		property["First obeys left identity"] = forAll { (i : MaybeOf<Int>) in
			return (First.mzero <> First(i.getMaybe)).value() == i.getMaybe
		}

		property["First obeys right identity"] = forAll { (i : MaybeOf<Int>) in
			return (First(i.getMaybe) <> First.mzero).value() == i.getMaybe
		}

		property["Last obeys left identity"] = forAll { (i : MaybeOf<Int>) in
			return (Last.mzero <> Last(i.getMaybe)).value() == i.getMaybe
		}

		property["Last obeys right identity"] = forAll { (i : MaybeOf<Int>) in
			return (Last(i.getMaybe) <> Last.mzero).value() == i.getMaybe
		}
	}

	func testDither() {
		let v : Dither<Product<Int8>, Sum<Int16>> = Dither([Either.Left(Product(2)), Either.Left(Product(3)), Either.Right(Sum(5)), Either.Left(Product(7))])
		XCTAssert(v.fold(onLeft: { n in Sum(Int16(n.value())) }, onRight: identity).value() == 18, "Dither works")
	}
}
