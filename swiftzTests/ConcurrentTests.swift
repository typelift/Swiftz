//
//  ConcurrentTests.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import swiftz

class ConcurrentTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
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

  func testConcurrentMVar() {
    var mvar: MVar<String> = MVar()
    let ft = Future<Void>(exec: gcdExecutionContext, { mvar.put("hello"); mvar.put("max") })
    XCTAssert(mvar.isEmpty(), "mvar is full")
    XCTAssert(mvar.take() == "hello", "mvar read")
    XCTAssert(mvar.take() == "max", "mvar read")
    XCTAssert(mvar.isEmpty(), "mvar empty")
  }
  
  func testPerformanceExample() {
    // concurrent pi
    
    func term(ch: Chan<CDouble>, k: CDouble) -> Void {
      ch <- (4 * pow(-1, k) / (2 * k + 1))
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
