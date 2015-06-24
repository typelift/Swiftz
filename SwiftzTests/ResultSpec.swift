//
//  ResultSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import Swiftz
import XCTest
import SwiftCheck

let defaultError = NSError(domain: "Swiftz", code: -1, userInfo: nil)

struct ResultOf<A : Arbitrary> : Arbitrary, CustomStringConvertible {
	let getResult : Result<A>

	init(_ maybe : Result<A>) {
		self.getResult = maybe
	}

	var description : String {
		return "\(self.getResult)"
	}

	private static func create(opt : Result<A>) -> ResultOf<A> {
		return ResultOf(opt)
	}

	static func arbitrary() -> Gen<ResultOf<A>> {
		return Gen.frequency([
			(1, Gen.pure(ResultOf(Result<A>.Error(defaultError)))),
			(3, liftM(ResultOf.init • Result<A>.pure)(m1: A.arbitrary()))
		])
	}

	static func shrink(bl : ResultOf<A>) -> [ResultOf<A>] {
		switch bl.getResult {
		case .Error(_):
			return []
		case let .Value(v):
			return [ResultOf(.Error(defaultError))] + A.shrink(v).map(ResultOf.init • Result.pure)
		}
	}
}

func == <T : protocol<Arbitrary, Equatable>>(lhs : ResultOf<T>, rhs : ResultOf<T>) -> Bool {
	return lhs.getResult == rhs.getResult
}

func != <T : protocol<Arbitrary, Equatable>>(lhs : ResultOf<T>, rhs : ResultOf<T>) -> Bool {
	return !(lhs == rhs)
}

class ResultSpec : XCTestCase {
	func testProperties() {
		property("There is an isomorphism between Either<NSError, A> and Result<A>") <- forAll { (l : ResultOf<Int>) in
			return l.getResult == l.getResult.toEither().toResult(identity)
		}

		property("Results of Equatable elements obey reflexivity") <- forAll { (l : ResultOf<Int>) in
			return l == l
		}

		property("Results of Equatable elements obey symmetry") <- forAll { (x : ResultOf<Int>, y : ResultOf<Int>) in
			return (x == y) == (y == x)
		}

		property("Results of Equatable elements obey transitivity") <- forAll { (x : ResultOf<Int>, y : ResultOf<Int>, z : ResultOf<Int>) in
			return (x == y) && (y == z) ==> (x == z)
		}

		property("Results of Equatable elements obey negation") <- forAll { (x : ResultOf<Int>, y : ResultOf<Int>) in
			return (x != y) == !(x == y)
		}

		property("Result obeys the Functor identity law") <- forAll { (x : ResultOf<Int>) in
			return (identity <^> x.getResult) == identity(x.getResult)
		}

		property("Result obeys the Functor composition law") <- forAll { (f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>, x : ResultOf<Int>) in
			return ((f.getArrow • g.getArrow) <^> x.getResult) == (f.getArrow <^> (g.getArrow <^> x.getResult))
		}

		property("Result obeys the Applicative identity law") <- forAll { (x : ResultOf<Int>) in
			return (Result.pure(identity) <*> x.getResult) == x.getResult
		}

		property("Result obeys the first Applicative composition law") <- forAll { (fl : ResultOf<ArrowOf<Int8, Int8>>, gl : ResultOf<ArrowOf<Int8, Int8>>, x : ResultOf<Int8>) in
			let f = { $0.getArrow } <^> fl.getResult
			let g = { $0.getArrow } <^> gl.getResult
			return (curry(•) <^> f <*> g <*> x.getResult) == (f <*> (g <*> x.getResult))
		}

		property("Result obeys the second Applicative composition law") <- forAll { (fl : ResultOf<ArrowOf<Int8, Int8>>, gl : ResultOf<ArrowOf<Int8, Int8>>, x : ResultOf<Int8>) in
			let f = { $0.getArrow } <^> fl.getResult
			let g = { $0.getArrow } <^> gl.getResult
			return (Result.pure(curry(•)) <*> f <*> g <*> x.getResult) == (f <*> (g <*> x.getResult))
		}

		property("Result obeys the Monad left identity law") <- forAll { (a : Int, fa : ArrowOf<Int, ResultOf<Int>>) in
			let f = { $0.getResult } • fa.getArrow
			return (Result.pure(a) >>- f) == f(a)
		}

		property("Result obeys the Monad right identity law") <- forAll { (m : ResultOf<Int>) in
			return (m.getResult >>- Result.pure) == m.getResult
		}

		property("Result obeys the Monad associativity law") <- forAll { (fa : ArrowOf<Int, ResultOf<Int>>, ga : ArrowOf<Int, ResultOf<Int>>, m : ResultOf<Int>) in
			let f = { $0.getResult } • fa.getArrow
			let g = { $0.getResult } • ga.getArrow
			return ((m.getResult >>- f) >>- g) == (m.getResult >>- { x in f(x) >>- g })
		}
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
}
