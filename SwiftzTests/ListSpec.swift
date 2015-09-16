//
//  ListSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

/// Generates an array of arbitrary values.
extension List where Element : Arbitrary {
	public static var arbitrary : Gen<List<Element>> {
		return List.init <^> [Element].arbitrary
	}

	public static func shrink(xs : List<Element>) -> [List<Element>] {
		return List.init <^> [Element].shrink(xs.map(identity))
	}
}

extension List : WitnessedArbitrary {
	public typealias Param = Element

	public static func forAllWitnessed<A : Arbitrary>(wit : A -> Element)(pf : (List<Element> -> Testable)) -> Property {
		return forAllShrink(List<A>.arbitrary, shrinker: List<A>.shrink, f: { bl in
			return pf(bl.map(wit))
		})
	}
}

class ListSpec : XCTestCase {
	func testProperties() {
		property("Lists of Equatable elements obey reflexivity") <- forAll { (l : List<Int>) in
			return l == l
		}

		property("Lists of Equatable elements obey symmetry") <- forAll { (x : List<Int>) in
			return forAll { (y : List<Int>) in
				return (x == y) == (y == x)
			}
		}

		property("Lists of Equatable elements obey transitivity") <- forAll { (x : List<Int>) in
			return forAll { (y : List<Int>) in
				let inner = forAll { (z : List<Int>) in
					return (x == y) && (y == z) ==> (x == z)
				}
				return inner
			}
		}

		property("Lists of Equatable elements obey negation") <- forAll { (x : List<Int>) in
			return forAll { (y : List<Int>) in
				return (x != y) == !(x == y)
			}
		}

		property("Lists of Comparable elements obey reflexivity") <- forAll { (l : List<Int>) in
			return l == l
		}

		property("List obeys the Functor identity law") <- forAll { (x : List<Int>) in
			return (x.fmap(identity)) == identity(x)
		}

		property("List obeys the Functor composition law") <- forAll { (f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>) in
			return forAll { (x : List<Int>) in
				return ((f.getArrow • g.getArrow) <^> x) == (x.fmap(g.getArrow).fmap(f.getArrow))
			}
		}

		property("List obeys the Applicative identity law") <- forAll { (x : List<Int>) in
			return (List.pure(identity) <*> x) == x
		}

		// Swift unroller can't handle our scale; Use only small lists.
		property("List obeys the first Applicative composition law") <- forAllShrink(List<ArrowOf<Int8, Int8>>.arbitrary, shrinker: List.shrink) { fl in
			return forAllShrink(List<ArrowOf<Int8, Int8>>.arbitrary, shrinker: List.shrink) { gl in
				return forAllShrink(List<Int8>.arbitrary, shrinker: List<Int8>.shrink) { x in
					return (fl.count <= 3 && gl.count <= 3) ==> {
						let f = fl.fmap({ $0.getArrow })
						let g = gl.fmap({ $0.getArrow })
						return (curry(•) <^> f <*> g <*> x) == (f <*> (g <*> x))
					}
				}
			}
		}

		property("List obeys the second Applicative composition law") <- forAllShrink(List<ArrowOf<Int8, Int8>>.arbitrary, shrinker: List.shrink) { fl in
			return forAllShrink(List<ArrowOf<Int8, Int8>>.arbitrary, shrinker: List.shrink) { gl in
				return forAllShrink(List<Int8>.arbitrary, shrinker: List<Int8>.shrink) { x in
					return (fl.count <= 3 && gl.count <= 3) ==> {
						let f = fl.fmap({ $0.getArrow })
						let g = gl.fmap({ $0.getArrow })
						return (List.pure(curry(•)) <*> f <*> g <*> x) == (f <*> (g <*> x))
					}
				}
			}
		}

		property("List obeys the Monoidal left identity law") <- forAll { (x : List<Int8>) in
			return (x <> List()) == x
		}

		property("List obeys the Monoidal right identity law") <- forAll { (x : List<Int8>) in
			return (List() <> x) == x
		}

		property("List can cycle into an infinite list") <- forAll { (x : List<Int8>) in
			return !x.isEmpty ==> {
				let cycle = x.cycle()

				return forAll { (n : Positive<Int>) in
					return (0...UInt(n.getPositive)).map({ i in cycle[i] == x[(i % x.count)] }).filter(==false).isEmpty
				}
			}
		}

		property("isEmpty behaves") <- forAll { (xs : List<Int>) in
			return xs.isEmpty == (xs.count == 0)
		}

		property("map behaves") <- forAll { (xs : List<Int>) in
			return xs.map(+1) == xs.fmap(+1)
		}

		property("map behaves") <- forAll { (xs : List<Int>) in
			let fs = { List<Int>.replicate(2, value: $0) }
			return (xs >>- fs) == xs.map(fs).reduce(+, initial: List())
		}

		property("filter behaves") <- forAll { (pred : ArrowOf<Int, Bool>) in
			return forAll { (xs : List<Int>) in
				return xs.filter(pred.getArrow).reduce({ $0.0 && pred.getArrow($0.1) }, initial: true)
			}
		}

		property("take behaves") <- forAll { (limit : UInt) in
			return forAll { (xs : List<Int>) in
				return xs.take(limit).count <= limit
			}
		}

		property("drop behaves") <- forAll { (limit : UInt) in
			return forAll { (xs : List<Int>) in
				let l = xs.drop(limit)
				if xs.count >= limit {
					return l.count == (xs.count - limit)
				}
				return l == []
			}
		}

		property("scanl behaves") <- forAll { (withArray : List<Int>) in
			let scanned = withArray.scanl(curry(+), initial: 0)
			switch withArray.match {
			case .Nil:
				return scanned == [0]
			case let .Cons(x, xs):
				let rig = (List.pure(0) + xs.scanl(curry(+), initial: 0 + x))
				return scanned == rig
			}
		}
	}
}
