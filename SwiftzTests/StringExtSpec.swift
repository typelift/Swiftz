//
//  StringExtSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

class StringExtSpec : XCTestCase {
	func testProperties() {
		property["unlines • lines === ('\n' • id)"] = forAll { (x : String) in
			let l = x.lines()
			let u = String.unlines(l)
			return u == (x + "\n")
		}

		property["Strings of Equatable elements obey reflexivity"] = forAll { (l : String) in
			return l == l
		}

		property["Strings of Equatable elements obey symmetry"] = forAll { (x : String, y : String) in
			return (x == y) == (y == x)
		}

		property["Strings of Equatable elements obey transitivity"] = forAll { (x : String, y : String, z : String) in
			if (x == y) && (y == z) {
				return x == z
			}
			return Discard()
		}

		property["Strings of Equatable elements obey negation"] = forAll { (x : String, y : String) in
			return (x != y) == !(x == y)
		}

		property["Strings of Comparable elements obey reflexivity"] = forAll { (l : String) in
			return l == l
		}

		property["String obeys the Functor identity law"] = forAll { (x : String) in
			return (x.fmap(identity)) == identity(x)
		}

//		reportProperty["String obeys the Functor composition law"] = forAll { (f : ArrowOf<Character, Character>, g : ArrowOf<Character, Character>, x : String) in
//			return ((f.getArrow • g.getArrow) <^> x) == (x.fmap(f.getArrow).fmap(g.getArrow))
//		}

		property["String obeys the Applicative identity law"] = forAll { (x : String) in
			return (pure(identity) <*> x) == x
		}

//		reportProperty["String obeys the first Applicative composition law"] = forAll { (fl : ListOf<ArrowOf<Character, Character>>, gl : ListOf<ArrowOf<Character, Character>>, x : String) in
//			let f = fl.fmap({ $0.getArrow })
//			let g = gl.fmap({ $0.getArrow })
//			return (curry(•) <^> f <*> g <*> x) == (f <*> (g <*> x))
//		}

//		reportProperty["String obeys the second Applicative composition law"] = forAll { (fl : ListOf<ArrowOf<Character, Character>>, gl : ListOf<ArrowOf<Character, Character>>, x : String) in
//			let f = fl.fmap({ $0.getArrow })
//			let g = gl.fmap({ $0.getArrow })
//			return (pure(curry(•)) <*> f <*> g <*> x) == (f <*> (g <*> x))
//		}

		property["String obeys the Monoidal left identity law"] = forAll { (x : String) in
			return (x + String.mzero) == x
		}

		property["String obeys the Monoidal right identity law"] = forAll { (x : String) in
			return (String.mzero + x) == x
		}

		property["map behaves"] = forAll { (xs : String) in
			return xs.map(identity) == xs.fmap(identity)
		}

		property["map behaves"] = forAll { (xs : String) in
			let fs : Character -> String = { String.replicate(2, value: $0) }
			return (xs >>- fs) == Array(xs).map(fs).reduce("", combine: +)
		}

//		reportProperty["filter behaves"] = forAll { (xs : String, pred : ArrowOf<Character, Bool>) in
//			return xs.filter(pred.getArrow).reduce({ $0.0 && pred.getArrow($0.1) }, initial: true)
//		}

		property["isPrefixOf behaves"] = forAll { (s1 : String, s2 : String) in
			if s1.isPrefixOf(s2) {
				return s1.stripPrefix(s2) != nil
			}

			if s2.isPrefixOf(s1) {
				return s2.stripPrefix(s1) != nil
			}

			return Discard()
		}

		property["isSuffixOf behaves"] = forAll { (s1 : String, s2 : String) in
			if s1.isSuffixOf(s2) {
				return s1.stripSuffix(s2) != nil
			}

			if s2.isSuffixOf(s1) {
				return s2.stripSuffix(s1) != nil
			}

			return Discard()
		}
	}
}
