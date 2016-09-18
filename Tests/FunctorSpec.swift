//
//  FunctorSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015-2016 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

class FunctorSpec : XCTestCase {
	func testProperties() {
		property("Const obeys the Functor identity law") <- forAll { (s : String) in
			let x = Const<String, String>(s)
			return (x.fmap(identity)).runConst == identity(x).runConst
		}

		property("Const obeys the Functor composition law") <- forAll { (_ f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>) in
			let x = Const<Int, Int>(5)
			return (x.fmap(f.getArrow • g.getArrow)).runConst == (x.fmap(g.getArrow).fmap(f.getArrow)).runConst
		}

		property("Const obeys the Bifunctor identity law") <- forAll { (s : String) in
			let x = Const<String, String>(s)
			let t : Const<String, String> = x.bimap(identity, identity)
			return t.runConst == identity(x).runConst
		}

		property("Const obeys the Biunctor composition law") <- forAll { (f1 : ArrowOf<Int, Int>, g1 : ArrowOf<Int, Int>, f2 : ArrowOf<Int, Int>, g2 : ArrowOf<Int, Int>) in
			let x = Const<Int, Int>(5)
			return x.bimap(f1.getArrow, g1.getArrow).bimap(f2.getArrow, g2.getArrow).runConst == (x.bimap(f2.getArrow • f1.getArrow, g1.getArrow • g2.getArrow)).runConst
		}
	}
}
