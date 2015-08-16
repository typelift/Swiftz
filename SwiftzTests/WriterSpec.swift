//
//  WriterSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 8/14/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

extension Writer where T : Arbitrary {
	public static var arbitrary : Gen<Writer<W, T>> {
		return Writer.init <^> Gen<()>.zip(T.arbitrary, Gen.pure(W.mempty))
	}
	
	public static func shrink(xs : Writer<W, T>) -> [Writer<W, T>] {
		let xs = T.shrink(xs.runWriter.0)
		return zip(xs, Array(count: xs.count, repeatedValue: W.mempty)).map(Writer.init)
	}
}

extension Writer : WitnessedArbitrary {
	public typealias Param = T
	
	public static func forAllWitnessed<W : Monoid, A : Arbitrary>(wit : A -> T)(pf : (Writer<W, T> -> Testable)) -> Property {
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
			return (x == y) && (y == z) ==> (x == z)
		}
		
		property("Writers obey negation") <- forAll { (x : Writer<String, Int>, y : Writer<String, Int>) in
			return (x != y) == !(x == y)
		}
		
		property("Writer obeys the Functor identity law") <- forAll { (x : Writer<String, Int>) in
			return (x.fmap(identity)) == identity(x)
		}
		
		property("Writer obeys the Functor composition law") <- forAll { (f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>) in
			return forAll { (x : Writer<String, Int>) in
				return ((f.getArrow • g.getArrow) <^> x) == (x.fmap(g.getArrow).fmap(f.getArrow))
			}
		}
		
// N.B. These are wrong, but they crash swiftc so...
//
//		property("Writer obeys the first Applicative composition law") <- forAll { (fl : Writer<String, ArrowOf<Int8, Int8>>, gl : Writer<String, ArrowOf<Int8, Int8>>, x : Writer<String, Int8>) in
//			let f = fl.fmap({ $0.getArrow })
//			let g = gl.fmap({ $0.getArrow })
//			return (curry(•) <^> f <*> g <*> x) == (f <*> (g <*> x))
//		}
		
//		property("Writer obeys the second Applicative composition law") <- forAll { (fl : Writer<String, ArrowOf<Int8, Int8>>, gl : Writer<String, ArrowOf<Int8, Int8>>, x : Writer<String, Int8>) in
//			let f = fl.fmap({ $0.getArrow })
//			let g = gl.fmap({ $0.getArrow })
//			return (Writer.pure(curry(•)) <*> f <*> g <*> x) == (f <*> (g <*> x))
//		}
		
//		property("Writer obeys the Monad left identity law") <- forAll { (a : Int, fa : ArrowOf<Int, Writer<String, Int>>) in
//			let f = fa.getArrow
//			return (Writer.pure(a) >>- f) == f(a)
//		}
		
//		property("Writer obeys the Monad right identity law") <- forAll { (m : Writer<String, Int>) in
//			return (m >>- Writer.pure) == m
//		}
		
//		property("Writer obeys the Monad associativity law") <- forAll { (fa : ArrowOf<Int, Writer<String, Int>>, ga : ArrowOf<Int, Writer<String, Int>>) in
//			let f = fa.getArrow
//			let g = ga.getArrow
//			return forAll { (m : Writer<String, Int>) in
//				return ((m >>- f) >>- g) == (m >>- { x in f(x) >>- g })
//			}
//		}
	}
}
