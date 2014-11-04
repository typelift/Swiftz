//
//  TestTests.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import swiftz
import swiftz_core

class TestTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testTestingSwiftCheck() {
    func prop_reverseLen(xs: [Int]) {
      XCTAssert(xs.reverse().count == xs.count)
    }

    func prop_reverseReverse(xs: [Int]) {
      XCTAssert(xs.reverse().reverse() == xs)
    }

//    swiftCheck(prop_reverseLen)
//    swiftCheck(prop_reverseReverse)

    // test guards work (they don't)
    func prop_linesUnlines(xs: String) {
      // guard(xs.last == "\n") { // just to test guarding, it's a bad guard
      XCTAssert((xs.lines() |> String.unlines) == xs)
      // }
    }

    // swiftCheck(prop_linesUnlines) // segfaults, can't explain this one
  }
}
