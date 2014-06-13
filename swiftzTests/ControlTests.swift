//
//  ControlTests.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import swiftz

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
    
    // function composition
    XCTAssert(comp({ $0.description })({ $0 + 1 })(0) == "1", "function composition")
    
    let composed = {(num:Int) in String(num) + String(1)} .... {$0 + 1} .... {$0 + 1} .... {$0 + 1}
    XCTAssert(composed(0) == "31", "Should be 31")
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
    
    func fs(x: Int) -> Array<Int> {
      return [x, x+1, x+2]
    }
    let rs = xs >>= fs
    XCTAssert(rs == [1, 2, 3, 2, 3, 4, 3, 4, 5], "array bind")
    
    XCTAssert(pure(1) == [1], "array pure")
  }
  
  func testLens() {
    let party = Party(h: User("max", 1, [], Dictionary()))
    // 10 points to who ever works out how to get it to work with function comp.
    // Party -> Host -> Name
//    let hostname: Party -> String = { Lens.get(Party.lpartyHost(), $0) |> { Lens.get(User.luserName(), $0) } }
//    let updatedParty: Party = Lens.modify(Party.lpartyHost(), { (Lens.set(User.luserName(), "Max", $0)) }, party)
//    XCTAssert(hostname(party) == "max")
//    XCTAssert(hostname(updatedParty) == "Max")
  }
}
