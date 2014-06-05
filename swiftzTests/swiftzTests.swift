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
      usleep(1)
      return 4
    })
    XCTAssert(x.result() == x.result(), "future")
    XCTAssert(x.map({ $0.description }).result() == "4", "future map")
    XCTAssert(x.flatMap({ (x: Int) -> Future<Int> in
      return Future(exec: gcdExecutionContext, { usleep(1); return x + 1 })
    }).result() == 5, "future flatMap")
    
    //    let x: Future<Int> = Future(exec: gcdExecutionContext, {
    //      return NSString.stringWithContentsOfURL(NSURL.URLWithString("http://github.com"), encoding: 0, error: nil)
    //    })
    //    let x1 = (x.result().lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    //    let x2 = (x.result().lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    //    XCTAssert(x1 == x2)
  }
  
  func testConcurrentChan() {
    var chan: Chan<Int> = Chan()
    let ft = Future<Int>(exec: gcdExecutionContext, { usleep(1); chan.write(2); return 2 })
    XCTAssert(chan.read() == ft.result(), "simple read chan")
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
  
  
  func testDataJSON() {
    let js: NSData = ("[1,\"foo\"]").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    let lhs: JSValue = JSValue.decode(js)
    let rhs: JSValue = JSValue.JSArray([JSValue.JSNumber(1), JSValue.JSString("foo")])
    XCTAssert(lhs == rhs)
    XCTAssert(rhs.encode() == js)
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
  
  func testDataOptionalExt() {
    let x = Optional.Some(4)
    func f(i: Int) -> Optional<Int> {
      if i % 2 == 0 {
        return .Some(i / 2)
      } else {
        return .None
      }
    }
    // rdar://17149404
//    XCTAssert(x.flatMap(f) == .Some(2), "optional flatMap")
  }
  
  func testMaybeOptionalExt() {
    let x = Optional.Some(4)
    let y = Optional<Int>.None

    //XCTAssert(x.maybe(0, { x in x + 1}) == 4, "maybe for Some works")
    //XCTAssert(y.maybe(0, { x in x + 1}) == 0, "maybe for None works")
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
    
    func term(ch: Chan<CDouble>, k: CDouble) -> Void {
      ch.write(4 * pow(-1, k) / (2 * k + 1))
    }
    
    func pi(n: Int) -> CDouble {
      let ch = Chan<CDouble>()
      for k in (0..n) {
        Future<Void>(exec: gcdExecutionContext, a: { return term(ch, CDouble(k)) })
      }
      var f = 0.0
      for k in (0..n) {
        f = f + ch.read()
      }
      return f
    }
    
    self.measureBlock() {
      pi(200)
      Void()
    }
  }
    
}
