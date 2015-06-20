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
struct ListOf<A : Arbitrary> : Arbitrary, CustomStringConvertible {
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
		return Gen.sized { n in
			return Gen<Int>.choose((0, n)).bind { k in
				if k == 0 {
					return Gen.pure(ListOf([]))
				}

				return sequence(Array((0...k)).map { _ in A.arbitrary() }).fmap({ ListOf.create(List(fromArray: $0)) })
			}
		}
	}

	static func shrink(bl : ListOf<A>) -> [ListOf<A>] {
		return ArrayOf.shrink(ArrayOf([A](bl.getList))).map({ ListOf(List(fromArray: $0.getArray)) })
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
			return (x == y) && (y == z) ==> (x == z)
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
			return ((f.getArrow • g.getArrow) <^> x.getList) == (x.getList.fmap(g.getArrow).fmap(f.getArrow))
		}

		property["List obeys the Applicative identity law"] = forAll { (x : ListOf<Int>) in
			return (List.pure(identity) <*> x.getList) == x.getList
		}

		// Swift unroller can't handle our scale.
//		property["List obeys the first Applicative composition law"] = forAll { (fl : ListOf<ArrowOf<Int8, Int8>>, gl : ListOf<ArrowOf<Int8, Int8>>, x : ListOf<Int8>) in
//			let f = fl.getList.fmap({ $0.getArrow })
//			let g = gl.getList.fmap({ $0.getArrow })
//			return (curry(•) <^> f <*> g <*> x.getList) == (f <*> (g <*> x.getList))
//		}
//
//		property["List obeys the second Applicative composition law"] = forAll { (fl : ListOf<ArrowOf<Int8, Int8>>, gl : ListOf<ArrowOf<Int8, Int8>>, x : ListOf<Int8>) in
//			let f = fl.getList.fmap({ $0.getArrow })
//			let g = gl.getList.fmap({ $0.getArrow })
//			return (List.pure(curry(•)) <*> f <*> g <*> x.getList) == (f <*> (g <*> x.getList))
//		}

		property["List obeys the Monoidal left identity law"] = forAll { (x : ListOf<Int8>) in
			return (x.getList + List()) == x.getList
		}

		property["List obeys the Monoidal right identity law"] = forAll { (x : ListOf<Int8>) in
			return (List() + x.getList) == x.getList
		}

		property["List can cycle into an infinite list"] = forAll { (x : ListOf<Int8>) in
			return !x.getList.isEmpty() ==> {
				let finite = x.getList
				let cycle = finite.cycle()

				return forAll { (n : Positive<Int>) in
					return (0...UInt(n.getPositive)).map({ i in cycle[i] == finite[(i % finite.length())] }).filter(==false).isEmpty
				}
			}
		}

		property["isEmpty behaves"] = forAll { (xs : ListOf<Int>) in
			return xs.getList.isEmpty() == (xs.getList.length() == 0)
		}

		property["map behaves"] = forAll { (xs : ListOf<Int>) in
			return xs.getList.map(+1) == xs.getList.fmap(+1)
		}

		property["map behaves"] = forAll { (xs : ListOf<Int>) in
			let fs = { List<Int>.replicate(2, value: $0) }
			return (xs.getList >>- fs) == xs.getList.map(fs).reduce(+, initial: List())
		}

		property["filter behaves"] = forAll { (xs : ListOf<Int>, pred : ArrowOf<Int, Bool>) in
			return xs.getList.filter(pred.getArrow).reduce({ $0.0 && pred.getArrow($0.1) }, initial: true)
		}

		property["take behaves"] = forAll { (xs : ListOf<Int>, limit : UInt) in
			return xs.getList.take(limit).length() <= limit
		}

		property["drop behaves"] = forAll { (xs : ListOf<Int>, limit : UInt) in
			let l = xs.getList.drop(limit)
			if xs.getList.length() >= limit {
				return l.length() == (xs.getList.length() - limit)
			}
			return l == []
		}

		property["scanl behaves"] = forAll { (withArray : ListOf<Int>) in
			let scanned = withArray.getList.scanl(curry(+), initial: 0)
			switch withArray.getList.match() {
			case .Nil:
				return scanned == [0]
			case let .Cons(x, xs):
				return scanned == (List.pure(0) + xs.scanl(curry(+), initial: 0 + x))
			}
		}
	}
}
