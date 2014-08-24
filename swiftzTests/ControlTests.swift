//
//  ControlTests.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import swiftz
import swiftz_core

class ControlTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testBase() {
    let x = 1
    let y = 2
    // identity
    XCTAssert(identity(x) == x, "identity")

    // curry
    XCTAssert(curry({ (ab: (Int, Int)) -> Int in switch ab {
    case let (l, r): return (l + r)
      }}, x, y) == 3, "curry")
    XCTAssert(uncurry({
      (a: Int) -> Int -> Int in
      return ({(b: Int) -> Int in
        return (a + b)
      })
      }, (x, y)) == 3, "uncurry")

    // thrush
    XCTAssert((x |> {(a: Int) -> String in return a.description}) == "1", "thrush")
    //    XCTAssert((x <| {(a: Int) -> String in return a.description}) == 1, "unsafe tap")

    let x2 = 1 |> ({$0.advancedBy($0)}) |> ({$0.advancedBy($0)}) |> ({$0 * $0})
    XCTAssertTrue(x2 == 16, "Should equal 16")

    // flip
    XCTAssert(flip({ $0 / $1 }, 1, 0) == 0, "flip")
    XCTAssert(flip({ $0 / $1 })(b: 1, a: 0) == 0, "flip")
    XCTAssert(flip({ x in { x / $0 } })(b: 1)(a: 0) == 0, "flip")

    // function composition
    let composed2 = {(num:Int) in String(num) + String(1)} • {$0 + 1} • {$0 + 1} • {$0 + 1}
    XCTAssert(composed2(0) == "31", "Should be 31")
  }


  func testBaseOptional() {
    let x = Optional<Int>.Some(0)
    let y = Optional<Int>.None
    XCTAssert(({ $0 + 1 } <^> x) == 1, "optional map some")
    XCTAssert(({ $0 + 1 } <^> y) == .None, "optional map none")

    XCTAssert((Optional<Int -> Int>.Some({ $0 + 1 }) <*> .Some(1)) == 2, "apply some")

    XCTAssert((x >>= { Optional.Some($0 + 1) }) == .Some(1), "bind some")

    XCTAssert(pure(1) == .Some(1), "pure some")
  }

  func testBaseArray() {
    let xs = [1, 2, 3]
    let y = Optional<Int>.None
    let incedXs = ({ $0 + 1 } <^> xs)
    XCTAssert(incedXs == [2, 3, 4], "array fmap")
    XCTAssert(xs == [1, 2, 3], "fmap isn't destructive")

    XCTAssert((Optional<Int -> Int>.Some({ $0 + 1 }) <*> .Some(1)) == 2, "array apply")

    func fs(x: Int) -> [Int] {
      return [x, x+1, x+2]
    }
    let rs = xs >>= fs
    XCTAssert(rs == [1, 2, 3, 2, 3, 4, 3, 4, 5], "array bind")

    XCTAssert((pure(1) as [Int]) == [1], "array pure")
  }

  func testLens() {
    let party = Party(h: User("max", 1, [], Dictionary()))
    let hostnameLens = Party.lpartyHost() • User.luserName()

    XCTAssert(hostnameLens.get(party) == "max")

    let updatedParty: Party = (Party.lpartyHost() • User.luserName()).set(party, "Max")
    XCTAssert(hostnameLens.get(updatedParty) == "Max")
  }
}
