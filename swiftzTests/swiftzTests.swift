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
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measureBlock() {
        // Put the code you want to measure the time of here.
    }
  }
    
}
