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
	func testBase() {
		let x = 1
		let y = 2
		// identity
		XCTAssert(identity(x) == x, "identity")
		
		// curry
		XCTAssert(curry(+)(x)(y) == 3, "curry")
		XCTAssert(uncurry({ (a: Int) -> Int -> Int in
			return { b in (a + b) }
		})(x, y) == 3, "uncurry")
		
		// thrush
		XCTAssert((x |> { a in a.description }) == "1", "thrush")
		XCTAssert(({ a in a.description } <| x) == "1", "tap")
		
		let x2 = 1 |> { $0.advancedBy($0) } |> { $0.advancedBy($0) } |> { $0 * $0 }
		XCTAssertTrue(x2 == 16, "Should equal 16")
		
		// flip
		XCTAssert(flip(/, 1, 0) == 0, "flip")
		XCTAssert(flip(/)(b: 1, a: 0) == 0, "flip")
		XCTAssert(flip({ $0/ })(1)(0) == 0, "flip")
		
		// function composition
		let addThree = +1 • +1 • +1
		let composed2 : Int -> String = { num in String(num) + String(1) } • addThree
		XCTAssert(composed2(0) == "31", "Should be 31")
	}
	
	
	func testBaseOptional() {
		let x = Optional<Int>.Some(0)
		let y = Optional<Int>.None
		XCTAssert((+1 <^> x) == 1, "optional map some")
		XCTAssert((+1 <^> y) == .None, "optional map none")
				
		XCTAssert((.Some(+1) <*> .Some(1)) == 2, "apply some")
		
		XCTAssert((x >>- (pure • (+1))) == Optional<Int>.Some(1), "bind some")
		
		XCTAssert(pure(1) == .Some(1), "pure some")
	}
	
	func testBaseArray() {
		let xs = [1, 2, 3]
		let y = Optional<Int>.None
		let incedXs = (+1 <^> xs)
		XCTAssert(incedXs == [2, 3, 4], "array fmap")
		XCTAssert(xs == [1, 2, 3], "fmap isn't destructive")
		
		XCTAssert((.Some(+1) <*> .Some(1)) == 2, "array apply")
		
		func fs(x: Int) -> [Int] {
			return [x, x+1, x+2]
		}
		let rs = xs >>- fs
		XCTAssert(rs == [1, 2, 3, 2, 3, 4, 3, 4, 5], "array bind")
		
		XCTAssert(pure(1) == [1], "array pure")
	}
	
	func testLens() {
		let party = Party(h: User("max", 1, [], Dictionary()))
		let hostnameLens = Party.lpartyHost() • User.luserName()
		
		XCTAssert(hostnameLens.get(party) == "max")
		
		let updatedParty: Party = (Party.lpartyHost() • User.luserName()).set(party, "Max")
		XCTAssert(hostnameLens.get(updatedParty) == "Max")
	}
}
