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
		property["unlines • lines === id"] = forAll { (x : String) in
			return String.unlines(x.lines()) == x
		}
	}
}
