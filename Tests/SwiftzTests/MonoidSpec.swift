//
//  MonoidSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015-2016 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

class MonoidSpec : XCTestCase {
	func testProperties() {
		property("Sum obeys left identity") <- forAll { (i : Int) in
			return (Sum.mempty <> Sum(i)).value() == i
		}

		property("Sum obeys right identity") <- forAll { (i : Int) in
			return (Sum(i) <> Sum.mempty).value() == i
		}

		property("Product obeys left identity") <- forAll { (i : Int) in
			return (Product.mempty <> Product(i)).value() == i
		}

		property("Product obeys right identity") <- forAll { (i : Int) in
			return (Product(i) <> Product.mempty).value() == i
		}

		property("First obeys left identity") <- forAll { (i : Optional<Int>) in
			return (First.mempty <> First(i)).value() == i
		}

		property("First obeys right identity") <- forAll { (i : Optional<Int>) in
			return (First(i) <> First.mempty).value() == i
		}

		property("Last obeys left identity") <- forAll { (i : Optional<Int>) in
			return (Last.mempty <> Last(i)).value() == i
		}

		property("Last obeys right identity") <- forAll { (i : Optional<Int>) in
			return (Last(i) <> Last.mempty).value() == i
		}

		property("Unit obeys left identity") <- forAll { (i : Swiftz.Unit) in
			return (Unit.mempty <> i) == i
		}

		property("Unit obeys right identity") <- forAll { (i : Swiftz.Unit) in
			return (i <> Unit.mempty) == i
		}

		property("Proxy obeys left identity") <- forAll { (i : Proxy<Int>) in
			return (Proxy.mempty <> i) == i
		}

		property("Proxy obeys right identity") <- forAll { (i : Proxy<Int>) in
			return (i <> Proxy.mempty) == i
		}
	}

	func testDither() {
		let v : Dither<Product<Int8>, Sum<Int16>> = Dither([Either.Left(Product(2)), Either.Left(Product(3)), Either.Right(Sum(5)), Either.Left(Product(7))])
		XCTAssert(v.fold(onLeft: { n in Sum(Int16(n.value())) }, onRight: identity).value() == 18, "Dither works")
	}
}
