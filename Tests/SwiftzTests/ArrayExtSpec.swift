//
//  ArrayExtSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015-2016 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

class ArrayExtSpec : XCTestCase {
	func testProperties() {
		property("mapFlatten is the same as removing the optionals from an array and forcing") <- forAll { (xs0 : Array<OptionalOf<Int>>) in
			return mapFlatten(xs0.map({ $0.getOptional })) == xs0.filter({ $0.getOptional != nil }).map({ $0.getOptional! })
		}

		property("indexArray is safe") <- forAll { (l : [Int]) in
			if l.isEmpty {
				return l.safeIndex(0) == nil
			}
			return l.safeIndex(0) != nil
		}

		property("Array fmap is the same as map") <- forAll { (xs : [Int]) in
			return ({ $0 + 1 } <^> xs) == xs.map({ $0 + 1 })
		}

		property("Array pure give a singleton array") <- forAll { (x : Int) in
			return Array.pure(x) == [x]
		}

		property("Array bind works like a map then a concat") <- forAll { (xs : [Int]) in
			func fs(_ x : Int) -> [Int] {
				return [x, x+1, x+2]
			}

			return (xs >>- fs) == xs.map(fs).reduce([], +)
		}

		property("Array obeys the Functor identity law") <- forAll { (x : [Int]) in
			return (x.map(identity)) == identity(x)
		}

		property("Array obeys the Functor composition law") <- forAll { (_ f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>) in
			return forAll { (x : [Int]) in
				return ((f.getArrow • g.getArrow) <^> x) == (x.map(g.getArrow).map(f.getArrow))
			}
		}

		property("Array obeys the Applicative identity law") <- forAll { (x : [Int]) in
			return (Array.pure(identity) <*> x) == x
		}

		property("Array obeys the Applicative homomorphism law") <- forAll { (_ f : ArrowOf<Int, Int>, x : Int) in
			return (Array.pure(f.getArrow) <*> Array.pure(x)) == Array.pure(f.getArrow(x))
		}

		property("Array obeys the Applicative interchange law") <- forAll { (fu : Array<ArrowOf<Int, Int>>) in
			return forAll { (y : Int) in
				let u = fu.fmap { $0.getArrow }
				return (u <*> Array.pure(y)) == (Array.pure({ f in f(y) }) <*> u)
			}
		}

		property("Array obeys the first Applicative composition law") <- forAll { (fl : Array<ArrowOf<Int8, Int8>>, gl : Array<ArrowOf<Int8, Int8>>, x : Array<Int8>) in
			let f = fl.map({ $0.getArrow })
			let g = gl.map({ $0.getArrow })
			return (curry(•) <^> f <*> g <*> x) == (f <*> (g <*> x))
		}

		property("Array obeys the second Applicative composition law") <- forAll { (fl : Array<ArrowOf<Int8, Int8>>, gl : Array<ArrowOf<Int8, Int8>>, x : Array<Int8>) in
			let f = fl.map({ $0.getArrow })
			let g = gl.map({ $0.getArrow })
			return (Array.pure(curry(•)) <*> f <*> g <*> x) == (f <*> (g <*> x))
		}

		property("Array obeys the Monad left identity law") <- forAll { (a : Int, fa : ArrowOf<Int, ArrayOf<Int>>) in
			let f = { $0.getArray } • fa.getArrow
			return (Array.pure(a) >>- f) == f(a)
		}

		property("Array obeys the Monad right identity law") <- forAll { (m : [Int]) in
			return (m >>- Array.pure) == m
		}

		property("Array obeys the Monad associativity law") <- forAll { (fa : ArrowOf<Int, ArrayOf<Int>>, ga : ArrowOf<Int, ArrayOf<Int>>) in
			let f = { $0.getArray } • fa.getArrow
			let g = { $0.getArray } • ga.getArrow
			return forAll { (m : [Int]) in
				return ((m >>- f) >>- g) == (m >>- { x in f(x) >>- g })
			}
		}

		property("Array obeys the Monoidal left identity law") <- forAll { (x : Array<Int8>) in
			return (x <> []) == x
		}

		property("Array obeys the Monoidal right identity law") <- forAll { (x : Array<Int8>) in
			return ([] <> x) == x
		}

		property("scanl behaves") <- forAll { (withArray : [Int]) in
			let scanned = withArray.scanl(0, +)
			if withArray.isEmpty {
				return scanned == [0]
			}
			return scanned == [0] + [Int](withArray[1..<withArray.count]).scanl(0 + withArray.first!, +)
		}

		property("intersperse behaves") <- forAll { (withArray : [Int]) in
			let inter = withArray.intersperse(1)
			if withArray.isEmpty {
				return inter.isEmpty
			}
			return TestResult.succeeded // TODO: Test non-empty case
		}

		property("span behaves") <- forAll { (xs : [Int]) in
			return forAll { (pred : ArrowOf<Int, Bool>) in
				let p = xs.span(pred.getArrow)
				let t = (xs.takeWhile(pred.getArrow), xs.dropWhile(pred.getArrow))
				return p.0 == t.0 && p.1 == t.1
			}
		}

		property("extreme behaves") <- forAll { (xs : [Int]) in
			return forAll { (pred : ArrowOf<Int, Bool>) in
				let p = xs.extreme(pred.getArrow)
				let t = xs.span((!) • pred.getArrow)
				return p.0 == t.0 && p.1 == t.1
			}
		}

		property("intercalate behaves") <- forAll { (xs : [Int], xxsa : Array<ArrayOf<Int>>) in
			let xxs = xxsa.map { $0.getArray }
			return intercalate(xs, nested: xxs) == concat(xxs.intersperse(xs))
		}

		/*
		property("group for Equatable things is the same as groupBy(==)") <- forAll { (xs : [Int]) in
			return xs.group == xs.groupBy { $0 == $1 }
		}
		*/
		
		property("isPrefixOf behaves") <- forAll { (s1 : [Int], s2 : [Int]) in
			if s1.isPrefixOf(s2) {
				return s1.stripPrefix(s2) != nil
			}

			if s2.isPrefixOf(s1) {
				return s2.stripPrefix(s1) != nil
			}

			return Discard()
		}

		property("isSuffixOf behaves") <- forAll { (s1 : [Int], s2 : [Int]) in
			if s1.isSuffixOf(s2) {
				return s1.stripSuffix(s2) != nil
			}

			if s2.isSuffixOf(s1) {
				return s2.stripSuffix(s1) != nil
			}

			return Discard()
		}
		
		property("sequence occurs in order") <- forAll { (xs : [Int]) in
			let seq = sequence(xs.map(Array.pure))
			return forAllNoShrink(Gen.pure(seq)) { ss in
				return (ss.first ?? []) == xs
			}
		}
	}
}
