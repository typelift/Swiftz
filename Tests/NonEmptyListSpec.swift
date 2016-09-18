//
//  NonEmptyListSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 7/12/15.
//  Copyright © 2015-2016 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

extension NonEmptyList where Element : Arbitrary {
	public static var arbitrary : Gen<NonEmptyList<Element>> {
		return [Element].arbitrary.suchThat({ !$0.isEmpty }).map { NonEmptyList<Element>(List(fromArray: $0))! }
	}

	public static func shrink(_ xs : NonEmptyList<Element>) -> [NonEmptyList<Element>] {
		return List<Element>.shrink(xs.toList()).filter({ !$0.isEmpty }).flatMap { xs in
			return NonEmptyList(xs)!
		}
	}
}

extension NonEmptyList : WitnessedArbitrary {
	public typealias Param = Element

	public static func forAllWitnessed<A : Arbitrary>(_ wit : @escaping (A) -> Element, pf : @escaping (NonEmptyList<Element>) -> Testable) -> Property {
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
					return ((x == y) && (y == z)) ==> (x == z)
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

		property("NonEmptyList obeys the Functor composition law") <- forAll { (_ f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>) in
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

		property("NonEmptyList obeys the Monad left identity law") <- forAll { (a : Int, fa : ArrowOf<Int, Int>) in
			let f : (Int) -> NonEmptyList<Int> = NonEmptyList<Int>.pure • fa.getArrow
			return (NonEmptyList<Int>.pure(a) >>- f) == f(a)
		}

		property("NonEmptyList obeys the Monad right identity law") <- forAll { (m : NonEmptyList<Int>) in
			return (m >>- NonEmptyList<Int>.pure) == m
		}

		property("NonEmptyList obeys the Monad associativity law") <- forAll { (fa : ArrowOf<Int, Int>, ga : ArrowOf<Int, Int>) in
			let f : (Int) -> NonEmptyList<Int> = NonEmptyList<Int>.pure • fa.getArrow
			let g : (Int) -> NonEmptyList<Int> = NonEmptyList<Int>.pure • ga.getArrow
			return forAll { (m : NonEmptyList<Int>) in
				return ((m >>- f) >>- g) == (m >>- { x in f(x) >>- g })
			}
		}

		property("NonEmptyList obeys the Comonad identity law") <- forAll { (x : NonEmptyList<Int>) in
			return x.extend({ $0.extract() }) == x
		}

		property("NonEmptyList obeys the Comonad composition law") <- forAll { (ff : ArrowOf<Int, Int>) in
			return forAll { (x : Identity<Int>) in
				let f : (Identity<Int>) -> Int = ff.getArrow • { $0.runIdentity }
				return x.extend(f).extract() == f(x)
			}
		}

		property("NonEmptyList obeys the Comonad composition law") <- forAll { (ff : ArrowOf<Int, Int>, gg : ArrowOf<Int, Int>) in
			return forAll { (x : NonEmptyList<Int>) in
				let f : (NonEmptyList<Int>) -> Int = ff.getArrow • { $0.head }
				let g : (NonEmptyList<Int>) -> Int = gg.getArrow • { $0.head }
				return x.extend(f).extend(g) == x.extend({ g($0.extend(f)) })
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
