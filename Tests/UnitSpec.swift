//
//  UnitSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 12/11/15.
//  Copyright © 2015-2016 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

extension Swiftz.Unit : Arbitrary {
	public static var arbitrary : Gen<Swiftz.Unit> {
		return Gen.pure(.TT)
	}
}

extension Swiftz.Unit : CoArbitrary {
	public static func coarbitrary<C>(_ : Swiftz.Unit) -> ((Gen<C>) -> Gen<C>) {
		return identity
	}
}

class UnitSpec : XCTestCase {
	func testProperties() {
		property("Swiftz.Unit obeys reflexivity") <- forAll { (l : Swiftz.Unit) in
			return l == l
		}

		property("Swiftz.Unit obeys symmetry") <- forAll { (x : Swiftz.Unit, y : Swiftz.Unit) in
			return (x == y) == (y == x)
		}

		property("Swiftz.Unit obeys transitivity") <- forAll { (x : Swiftz.Unit, y : Swiftz.Unit, z : Swiftz.Unit) in
			return ((x == y) && (y == z)) ==> (x == z)
		}

		property("Swiftz.Unit obeys negation") <- forAll { (x : Swiftz.Unit, y : Swiftz.Unit) in
			return (x != y) == !(x == y)
		}

		property("Swiftz.Unit's bounds are unique") <- forAll { (x : Swiftz.Unit) in
			return (Swiftz.Unit.minBound() == x) == (Swiftz.Unit.maxBound() == x)
		}
	}
}
