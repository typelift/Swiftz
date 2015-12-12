//
//  IdentitySpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 8/19/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

extension Identity where T : Arbitrary {
	public static var arbitrary : Gen<Identity<A>> {
		return Identity.pure <^> A.arbitrary
	}
}

extension Identity : WitnessedArbitrary {
	public typealias Param = T

	public static func forAllWitnessed<A : Arbitrary>(wit : A -> T)(pf : (Identity<T> -> Testable)) -> Property {
		return forAllShrink(Identity<A>.arbitrary, shrinker: const([]), f: { bl in
			return pf(bl.fmap(wit))
		})
	}
}

class IdentitySpec : XCTestCase {
	func testProperties() {
		property("Identity obeys the Functor identity law") <- forAll { (x : Identity<Int>) in
			return (x.fmap(identity)) == identity(x)
		}

		property("Identity obeys the Functor composition law") <- forAll { (f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>) in
			return forAll { (x : Identity<Int>) in
				return ((f.getArrow • g.getArrow) <^> x) == (x.fmap(g.getArrow).fmap(f.getArrow))
			}
		}

		property("Identity obeys the Applicative identity law") <- forAll { (x : Identity<Int>) in
			return (Identity.pure(identity) <*> x) == x
		}

		property("Identity obeys the Applicative homomorphism law") <- forAll { (f : ArrowOf<Int, Int>, x : Int) in
			return (Identity.pure(f.getArrow) <*> Identity.pure(x)) == Identity.pure(f.getArrow(x))
		}

		property("Identity obeys the Applicative interchange law") <- forAll { (fu : Identity<ArrowOf<Int, Int>>) in
			return forAll { (y : Int) in
				let u = fu.fmap { $0.getArrow }
				return (u <*> Identity.pure(y)) == (Identity.pure({ f in f(y) }) <*> u)
			}
		}

		property("Identity obeys the first Applicative composition law") <- forAll { (fl : Identity<ArrowOf<Int8, Int8>>, gl : Identity<ArrowOf<Int8, Int8>>, x : Identity<Int8>) in
			let f = fl.fmap({ $0.getArrow })
			let g = gl.fmap({ $0.getArrow })

			return (curry(•) <^> f <*> g <*> x) == (f <*> (g <*> x))
		}

		property("Identity obeys the second Applicative composition law") <- forAll { (fl : Identity<ArrowOf<Int8, Int8>>, gl : Identity<ArrowOf<Int8, Int8>>, x : Identity<Int8>) in
			let f = fl.fmap({ $0.getArrow })
			let g = gl.fmap({ $0.getArrow })

			return (Identity.pure(curry(•)) <*> f <*> g <*> x) == (f <*> (g <*> x))
		}

		property("Identity obeys the Monad left identity law") <- forAll { (a : Int, fa : ArrowOf<Int, Int>) in
			let f = Identity.pure • fa.getArrow
			return (Identity.pure(a) >>- f) == f(a)
		}

		property("Identity obeys the Monad right identity law") <- forAll { (m : Identity<Int>) in
			return (m >>- Identity.pure) == m
		}

		property("Identity obeys the Monad associativity law") <- forAll { (fa : ArrowOf<Int, Int>, ga : ArrowOf<Int, Int>) in
			let f = Identity.pure • fa.getArrow
			let g = Identity.pure • ga.getArrow
			return forAll { (m : Identity<Int>) in
				return ((m >>- f) >>- g) == (m >>- { x in f(x) >>- g })
			}
		}

		property("Identity obeys the Comonad identity law") <- forAll { (x : Identity<Int>) in
			return x.extend({ $0.extract() }) == x
		}

		property("Identity obeys the Comonad composition law") <- forAll { (ff : ArrowOf<Int, Int>) in
			return forAll { (x : Identity<Int>) in
				let f : Identity<Int> -> Int = ff.getArrow • { $0.runIdentity }
				return x.extend(f).extract() == f(x)
			}
		}

		property("Identity obeys the Comonad composition law") <- forAll { (ff : ArrowOf<Int, Int>, gg : ArrowOf<Int, Int>) in
			return forAll { (x : Identity<Int>) in
				let f : Identity<Int> -> Int = ff.getArrow • { $0.runIdentity }
				let g : Identity<Int> -> Int = gg.getArrow • { $0.runIdentity }
				return x.extend(f).extend(g) == x.extend({ g($0.extend(f)) })
			}
		}
	}
}
