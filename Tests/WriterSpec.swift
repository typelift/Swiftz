//
//  WriterSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 8/14/15.
//  Copyright © 2015-2016 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

extension Writer where T : Arbitrary {
	public static var arbitrary : Gen<Writer<W, T>> {
		return Gen<()>.zip(T.arbitrary, Gen.pure(W.mempty)).map(Writer.init)
	}

	public static func shrink(_ xs : Writer<W, T>) -> [Writer<W, T>] {
		let xs = T.shrink(xs.runWriter.0)
		return zip(xs, Array(repeating: W.mempty, count: xs.count)).map(Writer.init)
	}
}

extension Writer : WitnessedArbitrary {
	public typealias Param = T

	public static func forAllWitnessed<W : Monoid, A : Arbitrary>(_ wit : @escaping (A) -> T, pf : @escaping (Writer<W, T>) -> Testable) -> Property {
		return forAllShrink(Writer<W, A>.arbitrary, shrinker: Writer<W, A>.shrink, f: { bl in
			return pf(bl.fmap(wit))
		})
	}
}

class WriterSpec : XCTestCase {
	func testWriterProperties() {
		property("Writers obey reflexivity") <- forAll { (l : Writer<String, Int>) in
			return l == l
		}

		property("Writers obey symmetry") <- forAll { (x : Writer<String, Int>, y : Writer<String, Int>) in
			return (x == y) == (y == x)
		}

		property("Writers obey transitivity") <- forAll { (x : Writer<String, Int>, y : Writer<String, Int>, z : Writer<String, Int>) in
			return ((x == y) && (y == z)) ==> (x == z)
		}

		property("Writers obey negation") <- forAll { (x : Writer<String, Int>, y : Writer<String, Int>) in
			return (x != y) == !(x == y)
		}

		property("Writer obeys the Functor identity law") <- forAll { (x : Writer<String, Int>) in
			return (x.fmap(identity)) == identity(x)
		}

		property("Writer obeys the Functor composition law") <- forAll { (_ f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>) in
			return forAll { (x : Writer<String, Int>) in
				return ((f.getArrow • g.getArrow) <^> x) == (x.fmap(g.getArrow).fmap(f.getArrow))
			}
		}

		property("Writer obeys the first Applicative composition law") <- forAll { (fl : Writer<String, ArrowOf<Int8, Int8>>, gl : Writer<String, ArrowOf<Int8, Int8>>, x : Writer<String, Int8>) in
			let f = fl.fmap({ $0.getArrow })
			let g = gl.fmap({ $0.getArrow })
			return (curry(•) <^> f <*> g <*> x) == (f <*> (g <*> x))
		}

		property("Writer obeys the second Applicative composition law") <- forAll { (fl : Writer<String, ArrowOf<Int8, Int8>>, gl : Writer<String, ArrowOf<Int8, Int8>>, x : Writer<String, Int8>) in
			let f = fl.fmap({ $0.getArrow })
			let g = gl.fmap({ $0.getArrow })
			return (Writer<String, Int>.pure(curry(•)) <*> f <*> g <*> x) == (f <*> (g <*> x))
		}

		property("Writer obeys the Monad left identity law") <- forAll { (a : Int, fa : ArrowOf<Int, Int>) in
			let f : (Int) -> Writer<String, Int> = Writer<String, Int>.pure • fa.getArrow
			return (Writer<String, Int>.pure(a) >>- f) == f(a)
		}

		property("Writer obeys the Monad right identity law") <- forAll { (m : Writer<String, Int>) in
			return (m >>- Writer<String, Int>.pure) == m
		}

		property("Writer obeys the Monad associativity law") <- forAll { (fa : ArrowOf<Int, Int>, ga : ArrowOf<Int, Int>) in
			let f : (Int) -> Writer<String, Int> = Writer<String, Int>.pure • fa.getArrow
			let g : (Int) -> Writer<String, Int> = Writer<String, Int>.pure • ga.getArrow
			return forAll { (m : Writer<String, Int>) in
				return ((m >>- f) >>- g) == (m >>- { x in f(x) >>- g })
			}
		}

		property("sequence occurs in order") <- forAll { (xs : [String]) in
			let ws: [Writer<String, String>] = xs.map(Writer<String, String>.pure)
			let seq = sequence(ws)
			return forAllNoShrink(Gen.pure(seq)) { ss in
				return ss.runWriter.0 == xs
			}
		}
	}
}
