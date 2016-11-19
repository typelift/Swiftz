//
//  ArrowExtSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 8/16/15.
//  Copyright © 2015-2016 TypeLift. All rights reserved.
//

import Swiftz
import SwiftCheck
import XCTest

class ArrowExtSpec : XCTestCase {
	func testProperties() {
		property("Arrow obeys the Functor identity law") <- forAll { (x : ArrowOf<Int, Int>) in
			return forAll { (pt : Int) in
				return (identity <^> x.getArrow)(pt) == identity(x.getArrow)(pt)
			}
		}

		property("Arrow obeys the Functor composition law") <- forAll { (_ f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>, x : ArrowOf<Int, Int>) in
			return forAll { (pt : Int) in
				return ((f.getArrow • g.getArrow) <^> x.getArrow)(pt) == (f.getArrow <^> g.getArrow <^> x.getArrow)(pt)
			}
		}

		property("Arrow obeys the Applicative identity law") <- forAll { (x : ArrowOf<Int, Int>) in
			return forAll { (pt : Int) in
				return (const(identity) <*> x.getArrow)(pt) == x.getArrow(pt)
			}
		}
		
		property("Arrow obeys the Applicative homomorphism law") <- forAll { (_ f : ArrowOf<Int, Int>, x : Int) in
			return forAll { (pt : Int) in
				return (const(f.getArrow) <*> const(x))(pt) == const(f.getArrow(x))(pt)
			}
		}

		property("Arrow obeys the Applicative interchange law") <- forAll { (fu : ArrowOf<Int, ArrowOf<Int, Int>>, y : Int) in
			return forAll { (pt : Int) in
				let u = { $0.getArrow } • fu.getArrow
				return (u <*> const(y))(pt) == (const({ f in f(y) }) <*> u)(pt)
			}
		}

		property("Arrow obeys the first Applicative composition law") <- forAll { (fl : ArrowOf<Int8, ArrowOf<Int8, Int8>>, gl : ArrowOf<Int8, ArrowOf<Int8, Int8>>, xl : ArrowOf<Int8, Int8>) in
			let x = xl.getArrow
			let f = { $0.getArrow } • fl.getArrow
			let g = { $0.getArrow } • gl.getArrow
			return forAll { (pt : Int8) in
				return (curry(•) <^> f <*> g <*> x)(pt) == (f <*> (g <*> x))(pt)
			}
		}

		property("Arrow obeys the second Applicative composition law") <- forAll { (fl : ArrowOf<Int8, ArrowOf<Int8, Int8>>, gl : ArrowOf<Int8, ArrowOf<Int8, Int8>>, xl : ArrowOf<Int8, Int8>) in
			let x = xl.getArrow
			let f = { $0.getArrow } • fl.getArrow
			let g = { $0.getArrow } • gl.getArrow
			return forAll { (pt : Int8) in
				return (const(curry(•)) <*> f <*> g <*> x)(pt) == (f <*> (g <*> x))(pt)
			}
		}

		property("Arrow obeys the Monad left identity law") <- forAll { (a : Int, fa : ArrowOf<Int, ArrowOf<Int, Int>>) in
			let f = { $0.getArrow } • fa.getArrow
			return forAll { (pt : Int) in
				return (const(a) >>- f)(pt) == f(a)(pt)
			}
		}

		property("Arrow obeys the Monad right identity law") <- forAll { (m : ArrowOf<Int, Int>) in
			return forAll { (pt : Int) in
				return (m.getArrow >>- const)(pt) == m.getArrow(pt)
			}
		}

		property("Arrow obeys the Monad associativity law") <- forAll { (fa : ArrowOf<Int, ArrayOf<Int>>, ga : ArrowOf<Int, ArrayOf<Int>>) in
			let f = { $0.getArray } • fa.getArrow
			let g = { $0.getArray } • ga.getArrow
			return forAll { (m : [Int]) in
				return ((m >>- f) >>- g) == (m >>- { x in f(x) >>- g })
			}
		}
	}
}
