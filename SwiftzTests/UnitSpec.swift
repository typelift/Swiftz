//
//  UnitSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 12/11/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

extension Unit : Arbitrary {
	public static var arbitrary : Gen<Unit> {
		return Gen.pure(.TT)
	}
}

extension Unit : CoArbitrary {
	public static func coarbitrary<C>(_ : Unit) -> (Gen<C> -> Gen<C>) {
		return identity
	}
}

class UnitSpec : XCTestCase {
	func testProperties() {
		property("Unit obeys reflexivity") <- forAll { (l : Unit) in
			return l == l
		}

		property("Unit obeys symmetry") <- forAll { (x : Unit, y : Unit) in
			return (x == y) == (y == x)
		}

		property("Unit obeys transitivity") <- forAll { (x : Unit, y : Unit, z : Unit) in
			return (x == y) && (y == z) ==> (x == z)
		}

		property("Unit obeys negation") <- forAll { (x : Unit, y : Unit) in
			return (x != y) == !(x == y)
		}

		property("Unit's bounds are unique") <- forAll { (x : Unit) in
			return (Unit.minBound() == x) == (Unit.maxBound() == x)
		}
	}
}
