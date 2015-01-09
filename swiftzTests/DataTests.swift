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
	func testNum() {
		// TODO: test num
	}
	
	func testList() {
		let xs: List<(Int, String)> = [(1, "one"), (2, "two"), (3, "three")]
		let one: (Int, String) = xs.find({ (tp: (Int, String)) -> Bool in return (tp.0 == 1) })!
		XCTAssert(one.0 == 1 && one.1 == "one")
		
		let re: String? = xs.lookup(identity, key: 1)
		XCTAssert(re! == "one")
		
		self.measureBlock() {
			var lst: List<Int> = List()
			for x : Int in (0..<2600) {
				lst = List(x, lst)
			}
			XCTAssert(lst.length() == 2600)
		}

		let nats = List.iterate(+1, initial: 0)
		XCTAssertTrue(nats[0] == 0)
		XCTAssertTrue(nats[1] == 1)
		XCTAssertTrue(nats[2] == 2)

		let finite : List<UInt> = [1, 2, 3, 4, 5]
		let cycle = finite.cycle()
		for i : UInt in (0...100) {
			XCTAssertTrue(cycle[i] == finite[(i % 5)])
		}

		for i in finite {
			XCTAssertTrue(finite[i - 1] == i)
		}
	}

	func testListCombinators() {
		let t : List<Int> = [1, 2, 3]
		let u : List<Int> = [4, 5, 6]
		XCTAssert(t + u == [1, 2, 3, 4, 5, 6], "")

		let l : List<Int> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		XCTAssert(!l.isEmpty(), "")

		XCTAssert(l.map(+1) == [2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "")

		XCTAssert(l.concatMap({ List<Int>.replicate(2, value: $0) }) == [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10], "")
		XCTAssert(l.filter((==0) • (%2)) == [2, 4, 6, 8, 10], "")
		XCTAssert(l.reduce(curry(+), initial: 0) == 55, "")

		XCTAssert(u.scanl(curry(+), initial: 0) == [0, 4, 9, 15], "")
		XCTAssert(u.scanl1(curry(+)) == [4, 9, 15], "")
		XCTAssert(l.take(5) == [1, 2, 3, 4, 5], "")
		XCTAssert(l.drop(5) == [6, 7, 8, 9, 10], "")
	}
	
	func testListFunctor() {
		let x : List<Int> = [1, 2, 3]
		let y = x.fmap({ Double($0 * 2) })
		XCTAssert(y == [2.0, 4.0, 6.0])
	}
	
	func testNonEmptyListFunctor() {
		let x : NonEmptyList<Int> = [1, 2, 3]
		let y = x.fmap({ Double($0 * 2) })
		XCTAssert(y == [2.0, 4.0, 6.0])
	}
	
	func testEither() {
		func divTwoEvenly(x: Int) -> Either<String, Int> {
			if x % 2 == 0 {
				return Either.left("\(x) was div by 2")
			} else {
				return Either.right(x / 2)
			}
		}
		
		// either
		XCTAssert(Either.left("foo").either({ l in l+"!" }, { r in r+1 }) == "foo!")
		XCTAssert(Either.right(1).either({ l in l+"!" }, { r in r+1 }) == 2)
		
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
	
	func testResultFrom() {
		func throwableFunction(x : Int, e : NSErrorPointer) -> String {
			if x <= 0 {
				e.memory = NSError(domain: "TestErrorDomain", code: -1, userInfo: nil)
			}
			return "\(x)"
		}
		
		let e = NSError(domain: "TestErrorDomain", code: -1, userInfo: nil)
		XCTAssertTrue(from(throwableFunction)(-1) == Result.error(e), "")
		XCTAssertTrue(from(throwableFunction)(1) == Result.value("1"), "")
		
		XCTAssertTrue((throwableFunction !! -1) == Result.error(e), "")
		XCTAssertTrue((throwableFunction !! 1) == Result.value("1"), "")
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
	
	func testThose() {
		let this = Those<String, Int>.this("String")
		let that = Those<String, Int>.that(1)
		let both = Those<String, Int>.these("String", r: 1)
		
		XCTAssert((this.isThis() && that.isThat() && both.isThese()) == true, "")
		XCTAssert(this.toTuple("String", r: 1) == that.toTuple("String", r: 1), "")
		
		XCTAssert(both.bimap(identity, identity) == both, "")
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
		let y : Const<String, String>  = x.bimap({ "Why, " + $0 }, identity)
		XCTAssert(x.runConst != y.runConst)
	}
	
	func testTupleBifunctor() {
		let t : (Int, String) = (20, "Bottles of beer on the wall.")
		let y = TupleBF(t).bimap({ $0 - 1 }, identity)
		XCTAssert(y.0 != t.0)
		XCTAssert(y.1 == t.1)
	}
	
	func testMaybe() {
		let x = Maybe.just(10)
		let y = Maybe.just(7)
		let z = Maybe<Int>.none()
		
		XCTAssertTrue(x == x, "")
		XCTAssertTrue(y == y, "")
		XCTAssertTrue(z == z, "")

		XCTAssertTrue(x != y, "")
		XCTAssertTrue(x != z)
		XCTAssertTrue(y != z, "")
	}
	
	func testMaybeFunctor() {
		let x = Maybe.just(2)
		let y = x.fmap({ $0 * 2 })
		XCTAssert(y == Maybe.just(4))
		
		let a = Maybe<Int>.none()
		let b = a.fmap({ $0 * 2 })
		XCTAssert(b == a);
	}
	
	func testMaybeApplicative() {
		let x = Maybe<Int>.pure(2)
		let fn = Maybe.just({ $0 * 2 })
		let y = x.ap(fn)
		
		let fno = Maybe<Int -> String>.none()
		let b = x.ap(fno)
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
		XCTAssert(list.head == 10)
		XCTAssert(list.tail.head == "banana")
		XCTAssert(AList.length() == 2)
	}
	
}
