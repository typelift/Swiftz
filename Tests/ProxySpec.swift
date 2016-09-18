//
//  ProxySpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 7/20/15.
//  Copyright © 2015-2016 TypeLift. All rights reserved.
//  This file may be a carefully crafted joke.
//

import XCTest
import Swiftz
import SwiftCheck

extension Proxy : Arbitrary {
	public static var arbitrary : Gen<Proxy<T>> {
		return Gen.pure(Proxy())
	}
}

extension Proxy : CoArbitrary {
	public static func coarbitrary<C>(_ : Proxy<T>) -> ((Gen<C>) -> Gen<C>) {
		return identity
	}
}

class ProxySpec : XCTestCase {
	func testProperties() {
		property("Proxies obey reflexivity") <- forAll { (l : Proxy<Int>) in
			return l == l
		}

		property("Proxies obey symmetry") <- forAll { (x : Proxy<Int>, y : Proxy<Int>) in
			return (x == y) == (y == x)
		}

		property("Proxies obey transitivity") <- forAll { (x : Proxy<Int>, y : Proxy<Int>, z : Proxy<Int>) in
			return ((x == y) && (y == z)) ==> (x == z)
		}

		property("Proxies obey negation") <- forAll { (x : Proxy<Int>, y : Proxy<Int>) in
			return (x != y) == !(x == y)
		}

		property("Proxy's bounds are unique") <- forAll { (x : Proxy<Int>) in
			return (Proxy.minBound() == x) == (Proxy.maxBound() == x)
		}

		property("Proxy obeys the Functor identity law") <- forAll { (x : Proxy<Int>) in
			return (x.fmap(identity)) == identity(x)
		}

		property("Proxy obeys the Functor composition law") <- forAll { (_ f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>, x : Proxy<Int>) in
			return ((f.getArrow • g.getArrow) <^> x) == (x.fmap(g.getArrow).fmap(f.getArrow))
		}

		property("Proxy obeys the Applicative identity law") <- forAll { (x : Proxy<Int>) in
			return (Proxy.pure(identity) <*> x) == x
		}

		property("Proxy obeys the Applicative homomorphism law") <- forAll { (_ f : ArrowOf<Int, Int>, x : Int) in
			return (Proxy.pure(f.getArrow) <*> Proxy.pure(x)) == Proxy.pure(f.getArrow(x))
		}

		property("Proxy obeys the Applicative interchange law") <- forAll { (u : Proxy<(Int) -> Int>, y : Int) in
			return (u <*> Proxy.pure(y)) == (Proxy.pure({ f in f(y) }) <*> u)
		}

		property("Proxy obeys the first Applicative composition law") <- forAll { (_ f : Proxy<(Int) -> Int>, g : Proxy<(Int) -> Int>, x : Proxy<Int>) in
			return (curry(•) <^> f <*> g <*> x) == (f <*> (g <*> x))
		}

		/*
		property("Proxy obeys the second Applicative composition law") <- forAll { (_ f : Proxy<(Int) -> Int>, g : Proxy<(Int) -> Int>, x : Proxy<Int>) in
			return (Proxy<((Int) -> Int) -> ((Int) -> Int) -> (Int) -> Int>.pure(curry(•)) <*> f <*> g <*> x) == (f <*> (g <*> x))
		}
		*/
		
		property("Proxy obeys the Monad left identity law") <- forAll { (a : Int, fa : ArrowOf<Int, Proxy<Int>>) in
			let f = { $0 } • fa.getArrow
			return (Proxy.pure(a) >>- f) == f(a)
		}

		property("Proxy obeys the Monad right identity law") <- forAll { (m : Proxy<Int>) in
			return (m >>- Proxy.pure) == m
		}

		property("Proxy obeys the Monad associativity law") <- forAll { (fa : ArrowOf<Int, ArrayOf<Int>>, ga : ArrowOf<Int, ArrayOf<Int>>, m : ArrayOf<Int>) in
			let f = { $0.getArray } • fa.getArrow
			let g = { $0.getArray } • ga.getArrow
			return ((m.getArray >>- f) >>- g) == (m.getArray >>- { x in f(x) >>- g })
		}

		property("Proxy obeys the Comonad identity law") <- forAll { (x : Proxy<Int>) in
			return x.extend({ $0.extract() }) == x
		}

// Can't test ⊥ == ⊥ in this language.
//		property("Proxy obeys the Comonad composition law") <- forAll { (ff : ArrowOf<Int, Int>) in
//			return forAll { (x : Proxy<Int>) in
//				let f : Proxy<Int> -> Int = ff.getArrow • const(0)
//				return x.extend(f).extract() == f(x)
//			}
//		}

		property("Proxy obeys the Comonad composition law") <- forAll { (ff : ArrowOf<Int, Int>, gg : ArrowOf<Int, Int>) in
			return forAll { (x : Proxy<Int>) in
				let f : (Proxy<Int>) -> Int = ff.getArrow • const(0)
				let g : (Proxy<Int>) -> Int = gg.getArrow • const(0)
				return x.extend(f).extend(g) == x.extend({ f($0.extend(g)) })
			}
		}

		// Proxy throws away its contents, and just acts as a Proxy for a type.
		property("sequence occurs in order") <- forAll { (xs : [String]) in
			let seq = sequence(xs.map(Proxy.pure))
			return forAllNoShrink(Gen.pure(seq)) { ss in
				return ss.self == Proxy.pure(xs).self
			}
		}
	}
}

