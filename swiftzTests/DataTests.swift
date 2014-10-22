//
//  DataTests.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import swiftz
import swiftz_core

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

  func testEither() {
    func divTwoEvenly(x: Int) -> Either<String, Int> {
      if x % 2 == 0 {
        return Either.left("\(x) was div by 2")
      } else {
        return Either.right(x / 2)
      }
    }

    // fold
    XCTAssert(Either.left("foo").fold(0, identity) == 0)
    XCTAssert(Either<String, Int>.right(10).fold(0, identity) == 10)

    // TODO: test <^>, <*> and pure

    let start = 17
    let first: Either<String, Int> = divTwoEvenly(start)
    let prettyPrinted: Either<String, String> = { $0.description } <^> first
    let snd = first >>- divTwoEvenly
    XCTAssert(prettyPrinted == Either.right("8"))
    XCTAssert(snd == Either.left("8 was div by 2"))
  }

  func testEitherBifunctor() {
    let x : Either<String, Int> = Either.right(2)
    let y = EitherBF(x).bimap(identity, { $0 * 2 })
    XCTAssert(y == Either.right(4))

    let a : Either<String, Int> = Either.left("Error!")
    let b = EitherBF(a).bimap(identity, { $0 * 2 })
    XCTAssert(b == a);
  }

  func testResult() {
    let divisionError = NSError(domain: "DivisionDomain", code: 1, userInfo: nil)

    func divTwoEvenly(x: Int) -> Result<Int> {
      if x % 2 == 0 {
        return Result.error(divisionError)
      } else {
        return Result.value(x / 2)
      }
    }

    // fold
    XCTAssert(Result.error(divisionError).fold(0, identity) == 0)
    XCTAssert(Result.value(10).fold(0, identity) == 10)

    let start = 17
    let first: Result<Int> = divTwoEvenly(start)
    let prettyPrinted: Result<String> = { $0.description } <^> first
    let snd = first >>- divTwoEvenly
    XCTAssert(prettyPrinted == Result.value("8"))
    XCTAssert(snd == .Error(divisionError))

    let startResult: Result<Int> = pure(start)
    XCTAssert(startResult == Result.value(17))
    let doubleResult: Result<Int -> Int> = pure({$0 * 2})
    XCTAssert((doubleResult <*> startResult) == Result.value(34), "test ap: (result, result)")
    let noF: Result<Int -> Int> = .Error(divisionError)
    let noX: Result<Int> = snd
    XCTAssert((noF <*> startResult) == .Error(divisionError), "test ap: (error, result)")
    XCTAssert((doubleResult <*> noX) == .Error(divisionError), "test ap: (result, error)")
    XCTAssert((noF <*> noX) == .Error(divisionError), "test ap: (error, error)")

    // special constructor
    XCTAssert(Result(divisionError, 1) == .Error(divisionError), "special Result cons error")
    XCTAssert(Result(nil, 1) == Result.value(1), "special Result cons value")
  }

  func testEitherResult() {
    // tests:
    // - either -> result
    // - result -> either

    let resultOne: Result<Int> = Result.value(1)
    let eitherOne: Either<NSError, Int> = resultOne.toEither()
    let resultAgain: Result<Int> = eitherOne.toResult(identity)
    XCTAssert(resultOne == resultAgain)

    let typeinfworkplz = Result.Value(Box(1)).toEither().toResult(identity)
  }

  func testFunctor() {
    // TODO: test functor in general?
  }

  func testApplicative() {
    //TODO: test applicative in general?
  }

  func testConst() {
    let s = "Goodbye!"
    let x : Const<String, String> = Const(s)
    XCTAssert(x.runConst == s)

    let b : Const<String, String> = x.fmap({ "I don't know why you say " + $0 })
    XCTAssert(b.runConst == s)
  }

  func testConstBifunctor() {
    let x : Const<String, String> = Const("Hello!")
    let y = ConstBF(x).bimap({ "Why, " + $0 }, g: identity)
    XCTAssert(x.runConst != y.runConst)
  }

  func testTupleBifunctor() {
    let t : (Int, String) = (20, "Bottles of beer on the wall.")
    let y = TupleBF(t).bimap({ $0 - 1 }, identity)
    XCTAssert(y.0 != t.0)
    XCTAssert(y.1 == t.1)
  }

  func testMaybeFunctor() {
    let x = Maybe.just(2)
    let y = MaybeF(x).fmap({ $0 * 2 })
    XCTAssert(y == Maybe.just(4))

    let a = Maybe<Int>.none()
    let b = MaybeF(a).fmap({ $0 * 2 })
    XCTAssert(b == a);
  }

  func testMaybeApplicative() {
    let x = MaybeF<Int, Int>.pure(2)
    let fn = Maybe.just({ $0 * 2 })
    let y = MaybeF(x).ap(fn)
    XCTAssert(y == Maybe.just(4))

    let fno = Maybe<Int -> String>.none()
    let b = MaybeF<Int, String>(x).ap(fno)
    XCTAssert(b == Maybe.none());
  }

  func testDataSemigroup() {
    let xs = [1, 2, 0, 3, 4]
    XCTAssert(sconcat(Min(), 2, xs) == 0, "sconcat works")
  }

  func testDataMonoid() {
    let xs: [Int8] = [1, 2, 0, 3, 4]
    XCTAssert(mconcat(Sum    <Int8, NInt8>(i: nint8), xs) == 10, "monoid sum works")
    XCTAssert(mconcat(Product<Int8, NInt8>(i: nint8), xs) == 0, "monoid product works")
  }

  func testDataJSON() {
    let js: NSData? = "[1,\"foo\"]".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    let lhs: JSONValue? = js >>- JSONValue.decode
    let rhs: JSONValue = .JSONArray([.JSONNumber(1), .JSONString("foo")])
    XCTAssertTrue(lhs != nil)
    XCTAssert(lhs! == rhs)
    XCTAssert(rhs.encode() == js)

    // user example
    let userjs: NSData? = "{\"name\": \"max\", \"age\": 10, \"tweets\": [\"hello\"], \"attrs\": {\"one\": \"1\"}}"
      .dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    let user: User? = userjs >>- JSONValue.decode >>- User.fromJSON
    XCTAssert(user! == User("max", 10, ["hello"], ["one": "1"]))

    // not a user, missing age
    let notuserjs: NSData? = "{\"name\": \"max\", \"tweets\": [\"hello\"], \"attrs\": {\"one\": \"1\"}}".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    let notUser: User? = notuserjs >>- JSONValue.decode >>- User.fromJSON
    if (notUser != nil) {
      XCTFail("expected none")
    }
  }

  func testInvalidDataJSON() {
    let js: NSData? = "[1,foo\"]".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    let json: JSONValue? = js >>- JSONValue.decode
    XCTAssertFalse(json != nil)
  }

  func testHList() {
    typealias AList = HCons<Int, HCons<String, HNil>>
    let list: AList = HCons(h: 10, t: HCons(h: "banana", t: HNil()))
    XCTAssert(list.head.value == 10)
    XCTAssert(list.tail.value.head.value == "banana")
    XCTAssert(AList.length() == 2)
  }

}
