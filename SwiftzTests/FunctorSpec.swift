//
//  FunctorSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

class FunctorSpec : XCTestCase {
	func testProperties() {
		property["Const obeys the Functor identity law"] = forAll { (s : String) in
			let x = Const<String, String>(s)
			return (x.fmap(identity)).runConst == identity(x).runConst
		}

		property["Const obeys the Functor composition law"] = forAll { (f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>) in
			let x = Const<Int, Int>(5)
			return (x.fmap(f.getArrow • g.getArrow)).runConst == (x.fmap(g.getArrow).fmap(f.getArrow)).runConst
		}
	}

	func testConstBifunctor() {
		let x : Const<String, String> = Const("Hello!")
		let y : Const<String, String>  = x.bimap({ "Why, " + $0 }, identity)
		XCTAssert(x.runConst != y.runConst)
	}

	func testTupleBifunctor() {
		let t : (Int, String) = (20, "Bottles of beer on the wall.")
		let y = TupleBF(t).bimap({ $0 - 1 }, identity)
		XCTAssert(y.0 != t.0)
		XCTAssert(y.1 == t.1)
	}
}
