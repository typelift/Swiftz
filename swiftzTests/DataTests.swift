//
//  DataTests.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
#if os(OSX)
import swiftz
#else
import swiftz_ios
#endif
import Basis
class DataTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testNum() {
    // TODO: test num
  }

    /// Commented out test never complete, and cause Xcode to hang in
    /// testing forever as of Beta 6.
    
//  func testList() {
//    let xs: List<(Int, String)> = [(1, "one"), (2, "two"), (3, "three")]
//    let one: (Int, String) = xs.find({ (tp: (Int, String)) -> Bool in return (tp.0 == 1) })!
//    XCTAssert(one.0 == 1 && one.1 == "one")
//
//    let re: String? = xs.lookup(identity, key: 1)
//    XCTAssert(re! == "one")
//
//    self.measureBlock() {
//      var lst: List<Int> = List()
//      for x: Int in (0..<26000) {
//        lst = List(x, lst)
//      }
//      XCTAssert(lst.length() == 26000)
//    }
//  }

//  func testListFunctor() {
//    let x : List<Int> = [1, 2, 3]
//    let y = ListF(l: x).fmap({ Double($0 * 2) })
//    XCTAssert(y == [2.0, 4.0, 6.0])
//  }

//  func testNonEmptyListFunctor() {
//    let x : NonEmptyList<Int> = [1, 2, 3]
//    let y = NonEmptyListF(l: x).fmap({ Double($0 * 2) })
//    XCTAssert(y == [2.0, 4.0, 6.0])
//  }

    // TODO: test <%>, <*> and pure


  func testConst() {
    let s = "Goodbye!"
    let x : Const<String, String> = Const(s)
    XCTAssert(x.runConst == s)

    let b : Const<String, String> = Const.fmap({ "I don't know why you say " + $0 })(x)
    XCTAssert(b.runConst == s)
  }

  func testDataSemigroup() {
    let xs = [1, 2, 0, 3, 4]
    XCTAssert(sconcat(Min(), 2, xs) == 0, "sconcat works")
  }
//
//  func testDataMonoid() {
//    let xs: [Int8] = [1, 2, 0, 3, 4]
//    XCTAssert(mconcat(Sum    <NInt8>(), xs) == 10, "monoid sum works")
//    XCTAssert(mconcat(Product<NInt8>(), xs) == 0, "monoid product works")
//  }

  func testDataJSON() {
    let js: NSData? = "[1,\"foo\"]".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    let lhs: JSValue? = js >>- JSValue.decode
    let rhs: JSValue = .JSArray([.JSNumber(1), .JSString("foo")])
    XCTAssertTrue(lhs != nil)
    XCTAssert(lhs! == rhs)
    XCTAssert(rhs.encode() == js)

    // user example
    let userjs: NSData? = "{\"name\": \"max\", \"age\": 10, \"tweets\": [\"hello\"], \"attrs\": {\"one\": \"1\"}}"
      .dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    let user: User? = userjs >>- JSValue.decode >>- User.fromJSON
    XCTAssert(user! == User("max", 10, ["hello"], ["one": "1"]))

    // not a user, missing age
    let notuserjs: NSData? = "{\"name\": \"max\", \"tweets\": [\"hello\"], \"attrs\": {\"one\": \"1\"}}".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    let notUser: User? = notuserjs >>- JSValue.decode >>- User.fromJSON
    if (notUser != nil) {
      XCTFail("expected none")
    }
  }

  func testInvalidDataJSON() {
    let js: NSData? = "[1,foo\"]".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    let json: JSValue? = js >>- JSValue.decode
    XCTAssertFalse(json != nil)
  }

  func testHList() {
    typealias AList = HCons<Int, HCons<String, HNil>>
    let list: AList = HCons(h: 10, t: HCons(h: "banana", t: HNil()))
    XCTAssert(list.head.unBox() == 10)
    XCTAssert(list.tail.unBox().head.unBox() == "banana")
    XCTAssert(AList.length() == 2)
  }

}
