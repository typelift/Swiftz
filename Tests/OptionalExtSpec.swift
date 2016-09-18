//
//  OptionalSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015-2016 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

class OptionalExtSpec : XCTestCase {
	func testProperties() {
		property("pure creates a .some") <- forAll { (x : Int) in
			return Optional.pure(x) == .some(x)
		}

		property("getOrElse behaves") <- forAll { (x : Optional<Int>) in
			if let y = x {
				return x.getOrElse(1) == y
			}
			return x.getOrElse(1) == 1
		}

		property("case analysis for Optionals behaves") <- forAll { (x : Optional<Int>) in
			if let y = x {
				return x.maybe(0, onSome: { $0 + 1 }) == (y + 1)
			}
			return x.maybe(0, onSome: { $0 + 1 }) == 0
		}

		property("Optional obeys the Functor identity law") <- forAll { (x : Optional<Int>) in
			return (x.map(identity)) == identity(x)
		}

		property("Optional obeys the Functor composition law") <- forAll { (_ f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>) in
			return forAll { (x : Optional<Int>) in
				return ((f.getArrow • g.getArrow) <^> x) == (x.map(g.getArrow).map(f.getArrow))
			}
		}

		property("Optional obeys the Applicative identity law") <- forAll { (x : Optional<Int>) in
			return (Optional.pure(identity) <*> x) == x
		}

		property("Optional obeys the Applicative homomorphism law") <- forAll { (_ f : ArrowOf<Int, Int>, x : Int) in
			return (Optional.pure(f.getArrow) <*> Optional.pure(x)) == Optional.pure(f.getArrow(x))
		}

		property("Optional obeys the Applicative interchange law") <- forAll { (fu : Optional<ArrowOf<Int, Int>>) in
			return forAll { (y : Int) in
				let u = fu.fmap { $0.getArrow }
				return (u <*> Optional.pure(y)) == (Optional.pure({ f in f(y) }) <*> u)
			}
		}

		property("Optional obeys the first Applicative composition law") <- forAll { (fl : Optional<ArrowOf<Int8, Int8>>, gl : Optional<ArrowOf<Int8, Int8>>, x : Optional<Int8>) in
			let f = fl.map({ $0.getArrow })
			let g = gl.map({ $0.getArrow })

			let l = (curry(•) <^> f <*> g <*> x)
			let r = (f <*> (g <*> x))
			return l == r
		}

		property("Optional obeys the second Applicative composition law") <- forAll { (fl : Optional<ArrowOf<Int8, Int8>>, gl : Optional<ArrowOf<Int8, Int8>>, x : Optional<Int8>) in
			let f = fl.map({ $0.getArrow })
			let g = gl.map({ $0.getArrow })

			let l = (Optional.pure(curry(•)) <*> f <*> g <*> x)
			let r = (f <*> (g <*> x))
			return l == r
		}

		property("Optional obeys the Monad left identity law") <- forAll { (a : Int, fa : ArrowOf<Int, OptionalOf<Int>>) in
			let f = { $0.getOptional } • fa.getArrow
			return (Optional.pure(a) >>- f) == f(a)
		}

		property("Optional obeys the Monad right identity law") <- forAll { (m : Optional<Int>) in
			return (m >>- Optional.pure) == m
		}

		property("Optional obeys the Monad associativity law") <- forAll { (fa : ArrowOf<Int, OptionalOf<Int>>, ga : ArrowOf<Int, OptionalOf<Int>>) in
			let f = { $0.getOptional } • fa.getArrow
			let g = { $0.getOptional } • ga.getArrow
			return forAll { (m : Optional<Int>) in
				return ((m >>- f) >>- g) == (m >>- { x in f(x) >>- g })
			}
		}
		
		property("Optional toEither behaves") <- forAll { (m : Optional<Int>) in
			let defaultValue = 0
			return (m.toEither(defaultValue).isLeft && m == nil) || ((m.toEither(defaultValue).isRight && m != nil))
		}

		property("sequence occurs in order") <- forAll { (xs : [String]) in
			let seq = sequence(xs.map(Optional.pure))
			return forAllNoShrink(Gen.pure(seq)) { ss in
				return ss! == xs
			}
		}
	}
}
