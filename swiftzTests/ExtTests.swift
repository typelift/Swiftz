//
//  ExtTests.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import swiftz

class ExtTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testTupleExt() {
    XCTAssert(fst((1,2)) == 1, "tuple fst")
    XCTAssert(snd((1,2)) == 2, "tuple snd")
  }
  
  func testArrayExt() {
    let xsO: Array<Optional<Int>> = [Optional.Some(1), .Some(2), .None]
    let exO: Array<Int> = mapFlatten(xsO)
    XCTAssert(exO == [1, 2], "mapflatten option")
    
    let exJ = join([[1, 2], [3, 4]])
    XCTAssert(exJ == [1, 2, 3, 4], "mapflatten option")
    
    XCTAssert(indexArray([1], 0) == 1, "index array 0")
    XCTAssert(indexArray(Array<Int>(), 0) == nil, "index array empty")
  }
  
  func testStringExt() {
    // some testing is done with properties in TestTests.swift
    XCTAssert(String.unlines("foo\nbar\n".lines()) == "foo\nbar\n", "lines / unlines a string")
  }
  
  func testOptionalExt() {
    let x = Optional.Some(4)
    let y = Optional<Int>.None
    func f(i: Int) -> Optional<Int> {
      if i % 2 == 0 {
        return .Some(i / 2)
      } else {
        return .None
      }
    }
    // rdar://17149404
    //    XCTAssert(x.flatMap(f) == .Some(2), "optional flatMap")
    //    maybe(...)
    //    XCTAssert(Optional.None.getOrElse(1) == 1, "optional getOrElse")
    
    //XCTAssert(x.maybe(0, { x in x + 1}) == 4, "maybe for Some works")
    //XCTAssert(y.maybe(0, { x in x + 1}) == 0, "maybe for None works")
  }
  
  func testDictionaryExt() {
    // TODO: test dictionary
  }
  
  func testDataNSDictionaryExt() {
    // TODO: test nsdictionary
  }
  
  func testNSArrayExt() {
    // TODO: test nsarray
  }
  
}
