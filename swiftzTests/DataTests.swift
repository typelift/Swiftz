//
//  DataTests.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import swiftz

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
  
  func testList() {
    let x : List<(Int, String)> = [(1, "one"), (2, "two"), (3, "three")]
    let one: (Int, String) = x.find({ (tp: (Int, String)) -> Bool in return (tp.0 == 1) })!
    XCTAssert(one.0 == 1 && one.1 == "one")
    
    // careful, nothing inference exists... always annotate Refl.
    let xs: List<Tuple2<Int, String>> = [Tuple2(a: 1, b: "one"), Tuple2(a: 2, b: "two")]
    let re: String? = xs.lookup(Refl<Tuple2<Int, String>>(), key: 1)
    XCTAssert(re! == "one")
    
    self.measureBlock() {
      var lst: List<Int> = List()
      for x: Int in (0..26000) {
        lst = List(x, lst)
      }
      XCTAssert(lst.length() == 26000)
    }
  }
  
  func testListFunctor() {
    let x : List<Int> = [1, 2, 3]
    let y = ListF(l: x).fmap({ Double($0 * 2) })
    XCTAssert(y == [2.0, 4.0, 6.0])
  }
  
  func testNonEmptyListFunctor() {
    let x : NonEmptyList<Int> = [1, 2, 3]
    let y = NonEmptyListF(l: x).fmap({ Double($0 * 2) })
    XCTAssert(y == [2.0, 4.0, 6.0])
  }
  
  func testEither() {
    func divTwoEvenly(x: Int) -> Either<String, Int> {
      if x % 2 == 0 {
        return .Left("\(x) was div by 2")
      } else {
        return .Right(x / 2)
      }
    }
    
    // TODO: test <^>, <*> and pure
    
    let start = 17
    let first: Either<String, Int> = divTwoEvenly(start)
    let prettyPrinted: Either<String, String> = { $0.description } <^> first
    let snd = first >>= divTwoEvenly
    XCTAssert(prettyPrinted == .Right("8"))
    XCTAssert(snd == .Left("8 was div by 2"))
  }
  
  func testResult() {
    // TODO: test <^>, <*> and pure
    
    let divisionError = NSError.errorWithDomain("DivisionDomain", code: 1, userInfo: nil)
    
    func divTwoEvenly(x: Int) -> Result<Int> {
      if x % 2 == 0 {
        return .Error(divisionError)
      } else {
        return .Value(x / 2)
      }
    }
    
    let start = 17
    let first: Result<Int> = divTwoEvenly(start)
    let prettyPrinted: Result<String> = { $0.description } <^> first
    let snd = first >>= divTwoEvenly
    XCTAssert(prettyPrinted == .Value("8"))
    XCTAssert(snd == .Error(divisionError))
    
    // special constructor
    XCTAssert(Result(divisionError, 1) == .Error(divisionError), "special Result cons error")
    XCTAssert(Result(nil, 1) == .Value(1), "special Result cons value")
  }
  
  func testEitherResult() {
    // tests:
    // - either -> result
    // - result -> either
    
    let resultOne: Result<Int> = Result.Value(1)
    let eitherOne: Either<NSError, Int> = resultOne.toEither()
    let resultAgain: Result<Int> = eitherOne.toResult(Refl())
    XCTAssert(resultOne == resultAgain)
    
    let typeinfworkplz = Result.Value(1).toEither().toResult(Refl())
  }
  
  func testFunctor() {
    // TODO: test functor in general?
  }
  
  func testApplicative() {
    //TODO: test applicative in general?
  }
  
  func testMaybeFunctor() {
    let x = Maybe.just(2)
    let y = MaybeF(m: x).fmap({ $0 * 2 })
    XCTAssert(y == Maybe.just(4))
    
    let a = Maybe<Int>.none()
    let b = MaybeF(m: a).fmap({ $0 * 2 })
    XCTAssert(b == a);
  }
  
  func testMaybeApplicative() {
    let x = MaybeF<Int, Int>.pure(2)
    let fn = Maybe.just({ $0 * 2 })
    let y = MaybeF(m: x).ap(fn)
    XCTAssert(y == Maybe.just(4))
    
    let fno = Maybe<Int -> String>.none()
    let b = MaybeF<Int, String>(m: x).ap(fno)
    XCTAssert(b == Maybe.none());
  }
  
  func testDataSemigroup() {
    let xs = [1, 2, 0, 3, 4]
    XCTAssert(sconcat(Min(), 2, xs) == 0, "sconcat works")
  }
  
  func testDataMonoid() {
    let xs: Int8[] = [1, 2, 0, 3, 4]
    XCTAssert(mconcat(Sum    <Int8, NInt8>(i: { return nint8 }), xs) == 10, "monoid sum works")
    XCTAssert(mconcat(Product<Int8, NInt8>(i: { return nint8 }), xs) == 0, "monoid product works")
  }

  func testDataJSON() {
    let js: NSData = "[1,\"foo\"]".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    let lhs: JSValue = JSValue.decode(js)
    let rhs: JSValue = .JSArray([.JSNumber(1), .JSString("foo")])
    XCTAssert(lhs == rhs)
    XCTAssert(rhs.encode() == js)
    
    // user example
    let userjs: NSData = "{\"name\": \"max\", \"age\": 10, \"tweets\": [\"hello\"], \"attrs\": {\"one\": \"1\"}}"
      .dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    let user: User? = JSValue.decode(userjs) >>= User.fromJSON
    XCTAssert(user! == User("max", 10, ["hello"], ["one": "1"]))
    
    // not a user, missing age
    let notuserjs: NSData = "{\"name\": \"max\", \"tweets\": [\"hello\"], \"attrs\": {\"one\": \"1\"}}".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    let notUser: User? = JSValue.decode(notuserjs) >>= User.fromJSON
    if notUser {
      XCTFail("expected none")
    }
  }
  
  func testHList() {
    typealias AList = HCons<Int, HCons<String, HNil>>
    let list: AList = HCons(h: 10, t: HCons(h: "banana", t: HNil()))
    XCTAssert(list.head.value == 10)
    XCTAssert(list.tail.value.head.value == "banana")
    XCTAssert(AList.length() == 2)
  }

}
