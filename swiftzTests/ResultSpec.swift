//
//  ResultSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import swiftz

class ResultSpec : XCTestCase {
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
}
