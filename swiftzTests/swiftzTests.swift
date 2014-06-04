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
  
  func testConcurrentFuture() {
    var e: NSError?
    let x: Future<Int> = Future(exec: gcdExecutionContext, {
      sleep(1)
      return 4
    })
    XCTAssert(x.result() == x.result(), "future")
    XCTAssert(x.map({ $0.description }).result() == "4", "future map")
    XCTAssert(x.flatMap({ (x: Int) -> Future<Int> in
      return Future(exec: gcdExecutionContext, { sleep(1); return x + 1 })
    }).result() == 5, "future flatMap")
    
    //    let x: Future<Int> = Future(exec: gcdExecutionContext, {
    //      return NSString.stringWithContentsOfURL(NSURL.URLWithString("http://github.com"), encoding: 0, error: nil)
    //    })
    //    let x1 = (x.result().lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    //    let x2 = (x.result().lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    //    XCTAssert(x1 == x2)
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
    
    XCTAssert((x |> {(a: Int) -> String in return a.description}) == "1", "thrush")
//    XCTAssert((x <| {(a: Int) -> String in return a.description}) == 1, "thrush")
    
  }
  
  func testDataSemigroup() {
    let xs = [1, 2, 0, 3, 4]
    XCTAssert(sconcat(Min(), 2, xs) == 0, "sconcat works")
  }
  
  func testDataMonoid() {
    let xs: Array<Int8> = [1, 2, 0, 3, 4]
    XCTAssert(mconcat(Sum    <Int8, NInt8>(i: { return nint8 }), xs) == 10, "monoid sum works")
    XCTAssert(mconcat(Product<Int8, NInt8>(i: { return nint8 }), xs) == 0, "monoid product works")
  }
  
//  func testDataList() {
//    let ls: List<Int> = .Nil()
//    println(ls)
//
//    XCTAssert(true, "Pass")
//  }

  func testDataOption() {
    // eq
    let m1: Optional<Int> = .None
    let m2: Optional<Int> = .Some(1)
    let m3: Optional<String> = .Some("swift")
    XCTAssert(m3 == .Some("swift"), "maybe eq")
    XCTAssert(m1 != m2, "maybe not eq")
    
    // ord
    XCTAssert(m1 <= m1, "Nothing <= Nothing")
    XCTAssert(!(m1 < m1), "Nothing >= Nothing")
    XCTAssert(m1 <= m2, "Nothing <= Just 1")
    XCTAssert(!(m2 <= m1), "Just 1 > Nothing")
    XCTAssert(m1 < m2, "Nothing < Just 1")
    XCTAssert(.Some(2) > m2, "Just 2 > Just 1")
    XCTAssert(m2 >= m1, "Nothing >= Just 1")
    
    // functor
    XCTAssert(m1.map({ (i: Int) -> Int in i + 1}) == .None, "map works")
    XCTAssert(m2.map({ (i: Int) -> Int in i + 1}) == .Some(2), "map still works")
  }
  
  func testDataArrayExt() {
    // segfaults. rdar://17148872
//    let xsO: Array<Optional<Int>> = [Optional.Some(1), .Some(2), .None]
//    let exO: Array<Int> = mapFlatten(xsO)
//    XCTAssert(exO == [1, 2], "mapflatten option")
//    
//    let exJ = join([[1, 2], [3, 4]])
//    XCTAssert(exJ == [1, 2, 3, 4], "mapflatten option")
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
