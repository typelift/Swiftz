//
//  ListSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

/// Generates an array of arbitrary values of type A.
struct ListOf<A : Arbitrary> : Arbitrary, Printable {
	let getList : List<A>

	init(_ array : List<A>) {
		self.getList = array
	}

	var description : String {
		return "\(self.getList)"
	}

	private static func create(array : List<A>) -> ListOf<A> {
		return ListOf(array)
	}

	static func arbitrary() -> Gen<ListOf<A>> {
		return sized { n in
			return choose((0, n)).bind { k in
				if k == 0 {
					return Gen.pure(ListOf([]))
				}

				return sequence(Array((0...k)).map { _ in A.arbitrary() }).fmap({ ListOf.create(List(fromArray: $0)) })
			}
		}
	}

	static func shrink(bl : ListOf<A>) -> [ListOf<A>] {
		switch bl.getList.match() {
		case .Nil:
			return []
		case let .Cons(x, xs):
			return [ ListOf<A>(xs) ] + ListOf<A>.shrink(ListOf<A>(xs)) + ListOf<A>.shrink(ListOf<A>(List(fromArray: A.shrink(x)) + xs))
		}
	}
}

func == <T : protocol<Arbitrary, Equatable>>(lhs : ListOf<T>, rhs : ListOf<T>) -> Bool {
	return lhs.getList == rhs.getList
}

func != <T : protocol<Arbitrary, Equatable>>(lhs : ListOf<T>, rhs : ListOf<T>) -> Bool {
	return !(lhs == rhs)
}

class ListSpec : XCTestCase {
	func testProperties() {
		property["Lists of Equatable elements obey reflexivity"] = forAll { (l : ListOf<Int>) in
			return l == l
		}

		property["Lists of Equatable elements obey symmetry"] = forAll { (x : ListOf<Int>, y : ListOf<Int>) in
			return (x == y) == (y == x)
		}

		property["Lists of Equatable elements obey transitivity"] = forAll { (x : ListOf<Int>, y : ListOf<Int>, z : ListOf<Int>) in
			if (x == y) && (y == z) {
				return x == z
			}
			return true // discard
		}

		property["Lists of Equatable elements obey negation"] = forAll { (x : ListOf<Int>, y : ListOf<Int>) in
			return (x != y) == !(x == y)
		}

		property["Lists of Comparable elements obey reflexivity"] = forAll { (l : ListOf<Int>) in
			return l == l
		}

		property["List obeys the Functor identity law"] = forAll { (x : ListOf<Int>) in
			return (x.getList.fmap(identity)) == identity(x.getList)
		}

		property["List obeys the Functor composition law"] = forAll { (f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>, x : ListOf<Int>) in
			return ((f.getArrow • g.getArrow) <^> x.getList) == (x.getList.fmap(f.getArrow).fmap(g.getArrow))
		}

		property["List obeys the Applicative identity law"] = forAll { (x : ListOf<Int>) in
			return (List.pure(identity) <*> x.getList) == x.getList
		}

		property["List obeys the first Applicative composition law"] = forAll { (fl : ListOf<ArrowOf<Int8, Int8>>, gl : ListOf<ArrowOf<Int8, Int8>>, x : ListOf<Int8>) in
			let f = fl.getList.fmap({ $0.getArrow })
			let g = gl.getList.fmap({ $0.getArrow })
			return (curry(•) <^> f <*> g <*> x.getList) == (f <*> (g <*> x.getList))
		}

		property["List obeys the second Applicative composition law"] = forAll { (fl : ListOf<ArrowOf<Int8, Int8>>, gl : ListOf<ArrowOf<Int8, Int8>>, x : ListOf<Int8>) in
			let f = fl.getList.fmap({ $0.getArrow })
			let g = gl.getList.fmap({ $0.getArrow })
			return (List.pure(curry(•)) <*> f <*> g <*> x.getList) == (f <*> (g <*> x.getList))
		}

		property["List obeys the Monoidal left identity law"] = forAll { (x : ListOf<Int8>) in
			return (x.getList + List()) == x.getList
		}

		property["List obeys the Monoidal right identity law"] = forAll { (x : ListOf<Int8>) in
			return (List() + x.getList) == x.getList
		}

		property["List can cycle into an infinite list"] = forAll { (x : ListOf<Int8>) in
			if x.getList.isEmpty() {
				return rejected()
			}

			let finite = x.getList
			let cycle = finite.cycle()
			for i : UInt in (0...100) {
				if cycle[i] != finite[(i % finite.length())] {
					return false
				}
			}
			return true
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
}
