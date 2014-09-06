//
//  SystemTests.swift
//  swiftz
//
//  Created by Robert Widmann on 9/5/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import swiftz_core
import swiftz

class SystemTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  
  func testPure() {
    let io = IO.pure(10)
    
    XCTAssertTrue(io.unsafePerformIO() == 10, "")
  }

  func testBind() {
    let io = IO.pure(10) >> IO.pure("String")
    
    XCTAssertTrue(io.unsafePerformIO() == "String", "")
  }
  
  func testLazyIO() {
    var str = ""
    let ios = [ IO.pure(str += "Yada "),
                IO.pure(str += "Yada "),
                IO.pure(str += "Yada "),
                IO.pure(str += "Yada "),
              ]

    let val: () = foldr(ios, IO.pure(()), >>).unsafePerformIO()
    
    XCTAssertTrue(str == "Yada Yada Yada Yada ", "")
  }
  
}
