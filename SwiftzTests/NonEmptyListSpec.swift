//
//  NonEmptyListSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 7/12/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

extension NonEmptyList where Element : Arbitrary {
	public static var arbitrary : Gen<NonEmptyList<Element>> {
		return [Element].arbitrary.suchThat({ !$0.isEmpty }).fmap { NonEmptyList<Element>(List(fromArray: $0))! }
	}

	public static func shrink(xs : NonEmptyList<Element>) -> [NonEmptyList<Element>] {
		return List<Element>.shrink(xs.toList()).filter({ !$0.isEmpty }).flatMap { xs in
			return NonEmptyList(xs)!
		}
	}
}

extension NonEmptyList : WitnessedArbitrary {
	public typealias Param = Element

	public static func forAllWitnessed<A : Arbitrary>(wit : A -> Element)(pf : (NonEmptyList<Element> -> Testable)) -> Property {
		return forAllShrink(NonEmptyList<A>.arbitrary, shrinker: NonEmptyList<A>.shrink, f: { bl in
			return pf(bl.fmap(wit))
		})
	}
}

class NonEmptyListSpec : XCTestCase {
	func testProperties() {
		property("Non-empty Lists of Equatable elements obey reflexivity") <- forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { l in
			return l == l
		}

		property("Non-empty Lists of Equatable elements obey symmetry") <- forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { x in
			return forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { y in
				return (x == y) == (y == x)
			}
		}

		property("Non-empty Lists of Equatable elements obey transitivity") <- forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { x in
			return forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { y in
				let inner = forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { z in
					return (x == y) && (y == z) ==> (x == z)
				}
				return inner
			}
		}

		property("Non-empty Lists of Equatable elements obey negation") <- forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { x in
			return forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { y in
				return (x != y) == !(x == y)
			}
		}

		property("Non-empty Lists of Comparable elements obey reflexivity") <- forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { l in
			return l == l
		}

		property("NonEmptyList obeys the Functor identity law") <- forAll { (x : NonEmptyList<Int>) in
			return (x.fmap(identity)) == identity(x)
		}

		property("NonEmptyList obeys the Functor composition law") <- forAll { (f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>) in
			return forAll { (x : NonEmptyList<Int>) in
				return ((f.getArrow • g.getArrow) <^> x) == (x.fmap(g.getArrow).fmap(f.getArrow))
			}
		}

		property("NonEmptyList obeys the Applicative identity law") <- forAll { (x : NonEmptyList<Int>) in
			return (NonEmptyList.pure(identity) <*> x) == x
		}

		// Swift unroller can't handle our scale; Use only small lists.
		property("NonEmptyList obeys the first Applicative composition law") <- forAll { (fl : NonEmptyList<ArrowOf<Int8, Int8>>, gl : NonEmptyList<ArrowOf<Int8, Int8>>, x : NonEmptyList<Int8>) in
			return (fl.count <= 3 && gl.count <= 3) ==> {
				let f = fl.fmap({ $0.getArrow })
				let g = gl.fmap({ $0.getArrow })
				return (curry(•) <^> f <*> g <*> x) == (f <*> (g <*> x))
			}
		}

		property("NonEmptyList obeys the second Applicative composition law") <- forAll { (fl : NonEmptyList<ArrowOf<Int8, Int8>>, gl : NonEmptyList<ArrowOf<Int8, Int8>>, x : NonEmptyList<Int8>) in
			return (fl.count <= 3 && gl.count <= 3) ==> {
				let f = fl.fmap({ $0.getArrow })
				let g = gl.fmap({ $0.getArrow })
				return (NonEmptyList.pure(curry(•)) <*> f <*> g <*> x) == (f <*> (g <*> x))
			}
		}

		property("head behaves") <- forAll { (x : Int) in
			return forAll { (xs : List<Int>) in
				return NonEmptyList(x, xs).head == x
			}
		}

		property("tail behaves") <- forAll { (x : Int) in
			return forAll { (xs : List<Int>) in
				return NonEmptyList(x, xs).tail == xs
			}
		}

		property("non-empty lists and lists that aren't empty are the same thing") <- forAll { (x : Int) in
			return forAll { (xs : List<Int>) in
				return NonEmptyList(x, xs).toList() == List(x, xs)
			}
		}

		property("optional constructor behaves") <- forAll { (xs : List<Int>) in
			switch xs.match {
			case .Nil:
				return NonEmptyList(xs) == nil
			case .Cons(let y, let ys):
				return NonEmptyList(xs)! == NonEmptyList(y, ys)
			}
		}

		property("NonEmptyList is a Semigroup") <- forAll { (l : NonEmptyList<Int>, r : NonEmptyList<Int>) in
			return (l <> r).toList() == l.toList() <> r.toList()
		}

		property("NonEmptyLists under double reversal is an identity") <- forAll { (l : NonEmptyList<Int>) in
			return l.reverse().reverse() == l
		}
	}
}
