//
//  StringExtSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

class StringExtSpec : XCTestCase {
	func testProperties() {
		property["unlines • lines === ('\n' • id)"] = forAll { (x : String) in
			let l = x.lines()
			let u = String.unlines(l)
			return u == (x + "\n")
		}
	}
}
