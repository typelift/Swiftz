//
//  ImArrayTests.swift
//  swiftz
//
//  Created by Terry Lewis II on 6/9/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
#if os(OSX)
import swiftz
#else
import swiftz_ios
#endif
import Basis

class ImArrayTests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }


  func testScanl() {
    let withArray = [1,2,3,4]
	let scanned = scanl(+)(q: 0)(ls: withArray)

    XCTAssert(scanned == [0,1,3,6,10], "Should be equal")
    XCTAssert(withArray == [1,2,3,4], "Should be equal(immutablility test)")
  }

  func testIntersperse() {
    let withArray = [1,2,3,4]
	let inter = intersperse(1)(l: withArray)

    XCTAssert(inter == [1,1,2,1,3,1,4], "Should be equal")
    XCTAssert(withArray == [1,2,3,4], "Should be equal(immutablility test)")

    let single = [1]
	XCTAssert(intersperse(1)(l: single) == [1], "Should be equal")
  }

  func testSplitAt() {
    let withArray = [1,2,3,4]

	let tuple = splitAt(2)(l: withArray)

    XCTAssert(tuple.0 == [1,2] && tuple.1 == [3,4], "Should be equal")

	XCTAssert(splitAt(0)(l: withArray).0 == Array() && splitAt(0)(l: withArray).1 == [1,2,3,4], "Should be equal")
    XCTAssert(withArray == [1,2,3,4], "Should be equal(immutablility test)")
  }

  func testAnd() {
    let withArray = [true, true, false, true]
    XCTAssertFalse(and(withArray), "Should be false")
  }

  func testOr() {
    let withArray = [true, true, false, true]
    XCTAssert(or(withArray), "Should be true")
  }

  func testAny() {
    let withArray = Array([1,4,5,7])
	XCTAssert(any({ $0 > 4 })(l: withArray), "Should be false")
  }

  func testAll() {
    let array = [1,3,24,5]
	XCTAssert(all({$0 <= 24})(l: array), "Should be true")
  }

  func testConcat() {
    let array = [[1,2,3],[4,5,6],[7],[8,9]]

    XCTAssert(concat(array) == [1,2,3,4,5,6,7,8,9], "Should be equal")
  }

  func testConcatMap() {
    let array = [1,2,3,4,5,6,7,8,9]

	XCTAssert(concatMap({a in [a + 1]})(l: array) == [2,3,4,5,6,7,8,9,10], "Should be equal")
  }

  func testSpan() {
    let withArray = [1,2,3,4,1,2,3,4]

	let tuple = span({a in {b in b < a}}(3))(l: withArray)
    XCTAssert(tuple.0 == [1,2] && tuple.1 == [3,4,1,2,3,4], "Should be equal")
  }

  func testGroup() {
    let array = [1,2,3,3,4,5,6,7,7,8,9,9,0]
    let result = group(array)

    XCTAssert(result == [[1],[2],[3,3],[4],[5],[6],[7,7],[8],[9,9],[0]], "Should be equal")
  }

  func testDropWhile() {
    let array = [1,2,3,4,5]

	XCTAssert(dropWhile({$0 <= 3})(l: array) == [4,5], "Should be equal")
  }

  func testTakeWhile() {
    let array = [1,2,3,4,5]

	XCTAssert(takeWhile({$0 <= 3})(l: array) == [1,2,3], "Should be equal")
  }
}
