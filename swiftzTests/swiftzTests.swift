//
//  swiftzTests.swift
//  swiftzTests
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import swiftz

class swiftzTests: XCTestCase {
    
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testControlBase() {
    let x = 1
    let y = 2
    XCTAssert(identity(x) == x, "identity")
    XCTAssert(curry({ (ab: (Int, Int)) -> Int in switch ab {
      case let (l, r): return (l + r)
    }}, x, y) == 3, "curry")
    XCTAssert(uncurry({
      (a: Int) -> Int -> Int in
      return ({(b: Int) -> Int in
        return (a + b)
      })
    }, (x, y)) == 3, "uncurry")
  }
  
//  func testDataList() {
//    let ls: List<Int> = .Nil()
//    println(ls)
//
//    XCTAssert(true, "Pass")
//  }

  func testDataMaybe() {
    // eq
    let m1: Maybe<Int> = .Nothing
    let m2: Maybe<Int> = .Just(1)
    let m3: Maybe<String> = .Just("swift")
    XCTAssert(m3 == .Just("swift"), "maybe eq")
    XCTAssert(m1 != m2, "maybe not eq")
    
    // ord
    XCTAssert(m1 <= m1, "Nothing <= Nothing")
    XCTAssert(!(m1 < m1), "Nothing >= Nothing")
    XCTAssert(m1 <= m2, "Nothing <= Just 1")
    XCTAssert(!(m2 <= m1), "Just 1 > Nothing")
    XCTAssert(m1 < m2, "Nothing < Just 1")
    XCTAssert(.Just(2) > m2, "Just 2 > Just 1")
    XCTAssert(m2 >= m1, "Nothing >= Just 1")
    
    // functor
    XCTAssert(m1.map({ (i: Int) -> Int in i + 1}, fc: m1) == .Nothing, "map works")
    XCTAssert(m1.map({ (i: Int) -> Int in i + 1}, fc: m2) == .Just(2), "map still works")
  }
  
//  func testDataEither() {
//    // eq
//    let m1: Either<String, Int> = .Left("fail")
//    let m2: Either<String, Int> = .Right(9001)
//    XCTAssert(m1 == .Left("fail"), "either eq")
//    XCTAssert(m1 != .Right(0), "either not eq")
//  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measureBlock() {
        // Put the code you want to measure the time of here.
    }
  }
    
}
