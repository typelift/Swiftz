//
//  MaybeSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

struct MaybeOf<A : Arbitrary> : Arbitrary, Printable {
	let getMaybe : Maybe<A>

	init(_ maybe : Maybe<A>) {
		self.getMaybe = maybe
	}

	var description : String {
		return "\(self.getMaybe)"
	}

	private static func create(opt : Maybe<A>) -> MaybeOf<A> {
		return MaybeOf(opt)
	}

	static func arbitrary() -> Gen<MaybeOf<A>> {
		return frequency([(1, Gen.pure(MaybeOf(Maybe<A>.none()))), (3, liftM({ MaybeOf(Maybe<A>.just($0)) })(m1: A.arbitrary()))])
	}

	static func shrink(bl : MaybeOf<A>) -> [MaybeOf<A>] {
		if bl.getMaybe.isJust() {
			return [MaybeOf(Maybe<A>.none())] + A.shrink(bl.getMaybe.fromJust()).map({ MaybeOf(Maybe<A>.just($0)) })
		}
		return []
	}
}

func == <T : protocol<Arbitrary, Equatable>>(lhs : MaybeOf<T>, rhs : MaybeOf<T>) -> Bool {
	return lhs.getMaybe == rhs.getMaybe
}

func != <T : protocol<Arbitrary, Equatable>>(lhs : MaybeOf<T>, rhs : MaybeOf<T>) -> Bool {
	return !(lhs == rhs)
}

class MaybeSpec : XCTestCase {
	func testProperties() {
		property["Maybes of Equatable elements obey reflexivity"] = forAll { (l : MaybeOf<Int>) in
			return l == l
		}

		property["Maybes of Equatable elements obey symmetry"] = forAll { (x : MaybeOf<Int>, y : MaybeOf<Int>) in
			return (x == y) == (y == x)
		}

		property["Maybes of Equatable elements obey transitivity"] = forAll { (x : MaybeOf<Int>, y : MaybeOf<Int>, z : MaybeOf<Int>) in
			if (x == y) && (y == z) {
				return x == z
			}
			return true // discard
		}

		property["Maybes of Equatable elements obey negation"] = forAll { (x : MaybeOf<Int>, y : MaybeOf<Int>) in
			return (x != y) == !(x == y)
		}

		property["Maybes of Comparable elements obey reflexivity"] = forAll { (l : MaybeOf<Int>) in
			return l == l
		}

		property["Maybe obeys the Functor identity law"] = forAll { (x : MaybeOf<Int>) in
			return (x.getMaybe.fmap(identity)) == identity(x.getMaybe)
		}

		property["Maybe obeys the Functor composition law"] = forAll { (f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>, x : MaybeOf<Int>) in
			return ((f.getArrow • g.getArrow) <^> x.getMaybe) == (x.getMaybe.fmap(f.getArrow).fmap(g.getArrow))
		}

		property["Maybe obeys the Applicative identity law"] = forAll { (x : MaybeOf<Int>) in
			return (Maybe.pure(identity) <*> x.getMaybe) == x.getMaybe
		}

		property["Maybe obeys the first Applicative composition law"] = forAll { (fl : MaybeOf<ArrowOf<Int8, Int8>>, gl : MaybeOf<ArrowOf<Int8, Int8>>, x : MaybeOf<Int8>) in
			let f = fl.getMaybe.fmap({ $0.getArrow })
			let g = gl.getMaybe.fmap({ $0.getArrow })
			return (curry(•) <^> f <*> g <*> x.getMaybe) == (f <*> (g <*> x.getMaybe))
		}

		property["Maybe obeys the second Applicative composition law"] = forAll { (fl : MaybeOf<ArrowOf<Int8, Int8>>, gl : MaybeOf<ArrowOf<Int8, Int8>>, x : MaybeOf<Int8>) in
			let f = fl.getMaybe.fmap({ $0.getArrow })
			let g = gl.getMaybe.fmap({ $0.getArrow })
			return (Maybe.pure(curry(•)) <*> f <*> g <*> x.getMaybe) == (f <*> (g <*> x.getMaybe))
		}
	}
}
