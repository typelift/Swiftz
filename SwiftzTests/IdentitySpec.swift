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

		property("Identity obeys the first Applicative composition law") <- forAll { (fl : Identity<ArrowOf<Int8, Int8>>, gl : Identity<ArrowOf<Int8, Int8>>, x : Identity<Int8>) in
			let f = fl.fmap({ $0.getArrow })
			let g = gl.fmap({ $0.getArrow })

			let l = (curry(•) <^> f <*> g <*> x)
			let r = (f <*> (g <*> x))
			return l == r
		}

		property("Identity obeys the second Applicative composition law") <- forAll { (fl : Identity<ArrowOf<Int8, Int8>>, gl : Identity<ArrowOf<Int8, Int8>>, x : Identity<Int8>) in
			let f = fl.fmap({ $0.getArrow })
			let g = gl.fmap({ $0.getArrow })

			let l = (Identity.pure(curry(•)) <*> f <*> g <*> x)
			let r = (f <*> (g <*> x))
			return l == r
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
	}
}
