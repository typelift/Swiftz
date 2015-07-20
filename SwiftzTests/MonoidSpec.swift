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

		property("First obeys left identity") <- forAll { (i : MaybeOf<Int>) in
			return (First.mempty <> First(i.getMaybe)).value() == i.getMaybe
		}

		property("First obeys right identity") <- forAll { (i : MaybeOf<Int>) in
			return (First(i.getMaybe) <> First.mempty).value() == i.getMaybe
		}

		property("Last obeys left identity") <- forAll { (i : MaybeOf<Int>) in
			return (Last.mempty <> Last(i.getMaybe)).value() == i.getMaybe
		}

		property("Last obeys right identity") <- forAll { (i : MaybeOf<Int>) in
			return (Last(i.getMaybe) <> Last.mempty).value() == i.getMaybe
		}
		
		property("Proxy obeys left identity") <- forAll { (i : Proxy<Int>) in
			return (Proxy.mzero <> i) == i
		}
		
		property("Proxy obeys right identity") <- forAll { (i : Proxy<Int>) in
			return (i <> Proxy.mzero) == i
		}
	}

	func testDither() {
		let v : Dither<Product<Int8>, Sum<Int16>> = Dither([Either.Left(Product(2)), Either.Left(Product(3)), Either.Right(Sum(5)), Either.Left(Product(7))])
		XCTAssert(v.fold(onLeft: { n in Sum(Int16(n.value())) }, onRight: identity).value() == 18, "Dither works")
	}
}
