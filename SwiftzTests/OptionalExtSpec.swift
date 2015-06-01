//
//  OptionalSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

class OptionalExtSpec : XCTestCase {
	func testProperties() {
		property["optional map behaves"] = forAll { (x : OptionalOf<Int>) in
			if let r = (+1 <^> x.getOptional) {
				return r == (x.getOptional! + 1)
			}
			return succeeded()
		}

		property["optional ap behaves"] = forAll { (x : OptionalOf<Int>) in
			if let r = (.Some(+1) <*> x.getOptional) {
				return r == (x.getOptional! + 1)
			}
			return succeeded()
		}

		property["optional bind behaves"] = forAll { (x : OptionalOf<Int>) in
			if let r = (x.getOptional  >>- (pure • (+1))) {
				return r == (x.getOptional! + 1)
			}
			return succeeded()
		}

		property["pure creates a .Some"] = forAll { (x : Int) in
			return pure(x) == .Some(x)
		}

		property["getOrElse behaves"] = forAll { (x : OptionalOf<Int>) in
			if let y = x.getOptional {
				return getOrElse(x.getOptional)(1) == y
			}
			return getOrElse(x.getOptional)(1) == 1
		}

		property["case analysis for Optionals behaves"] = forAll { (x : OptionalOf<Int>) in
			if let y = x.getOptional {
				return maybe(x.getOptional)(0)(+1) == (y + 1)
			}
			return maybe(x.getOptional)(0)(+1) == 0
		}

		property["Optional obeys the Functor identity law"] = forAll { (x : OptionalOf<Int>) in
			return (x.getOptional.map(identity)) == identity(x.getOptional)
		}

		property["Optional obeys the Functor composition law"] = forAll { (f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>, x : OptionalOf<Int>) in
			return ((f.getArrow • g.getArrow) <^> x.getOptional) == (x.getOptional.map(g.getArrow).map(f.getArrow))
		}

		property["Optional obeys the Applicative identity law"] = forAll { (x : OptionalOf<Int>) in
			return (pure(identity) <*> x.getOptional) == x.getOptional
		}

		property["Optional obeys the first Applicative composition law"] = forAll { (fl : OptionalOf<ArrowOf<Int8, Int8>>, gl : OptionalOf<ArrowOf<Int8, Int8>>, x : OptionalOf<Int8>) in
			let f = fl.getOptional.map({ $0.getArrow })
			let g = gl.getOptional.map({ $0.getArrow })

			let l = (curry(•) <^> f <*> g <*> x.getOptional)
			let r = (f <*> (g <*> x.getOptional))
			return l == r
		}

		property["Optional obeys the second Applicative composition law"] = forAll { (fl : OptionalOf<ArrowOf<Int8, Int8>>, gl : OptionalOf<ArrowOf<Int8, Int8>>, x : OptionalOf<Int8>) in
			let f = fl.getOptional.map({ $0.getArrow })
			let g = gl.getOptional.map({ $0.getArrow })

			let l = (pure(curry(•)) <*> f <*> g <*> x.getOptional)
			let r = (f <*> (g <*> x.getOptional))
			return l == r
		}

		property["Optional obeys the Monad left identity law"] = forAll { (a : Int, fa : ArrowOf<Int, OptionalOf<Int>>) in
			let f = { $0.getOptional } • fa.getArrow
			return (pure(a) >>- f) == f(a)
		}

		property["Optional obeys the Monad right identity law"] = forAll { (m : OptionalOf<Int>) in
			return (m.getOptional >>- pure) == m.getOptional
		}

		property["Optional obeys the Monad associativity law"] = forAll { (fa : ArrowOf<Int, OptionalOf<Int>>, ga : ArrowOf<Int, OptionalOf<Int>>, m : OptionalOf<Int>) in
			let f = { $0.getOptional } • fa.getArrow
			let g = { $0.getOptional } • ga.getArrow
			return ((m.getOptional >>- f) >>- g) == (m.getOptional >>- { x in f(x) >>- g })
		}
	}
}
