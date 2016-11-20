//
//  TupleExtSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015-2016 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

class TupleExtSpec : XCTestCase {
	func testProperties() {
		property("fst behaves") <- forAll { (x : Int, y : Int) in
			return fst((x, y)) == x
		}

		property("snd behaves") <- forAll { (x : Int, y : Int) in
			return snd((x, y)) == y
		}
	}
}
