//
//  NonEmptyListSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 7/12/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

extension NonEmptyList where A : Arbitrary {
	public static var arbitrary : Gen<NonEmptyList<A>> {
		return [A].arbitrary.suchThat({ !$0.isEmpty }).fmap { NonEmptyList<A>(List(fromArray: $0))! }
	}
	
	public static func shrink(xs : NonEmptyList<A>) -> [NonEmptyList<A>] {
		return List<A>.shrink(xs.toList()).filter({ !$0.isEmpty }).flatMap { xs in
			return NonEmptyList(xs)!
		}
	}
}

class NonEmptyListSpec : XCTestCase {
	func testProperties() {
		property("Non-empty Lists of Equatable elements obey reflexivity") <- forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { l in
			return l == l
		}
		
		property("Non-empty Lists of Equatable elements obey symmetry") <- forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { x in
			return forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { y in
				return (x == y) == (y == x)
			}
		}
		
		property("Non-empty Lists of Equatable elements obey transitivity") <- forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { x in
			return forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { y in
				let inner = forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { z in
					return (x == y) && (y == z) ==> (x == z)
				}
				return inner
			}
		}
		
		property("Non-empty Lists of Equatable elements obey negation") <- forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { x in
			return forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { y in
				return (x != y) == !(x == y)
			}
		}
		
		property("Non-empty Lists of Comparable elements obey reflexivity") <- forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { l in
			return l == l
		}
		
		property("head behaves") <- forAll { (x : Int) in
			return forAllShrink(List<Int>.arbitrary, shrinker: List<Int>.shrink) { xs in
				return NonEmptyList(x, xs).head == x
			}
		}
		
		property("tail behaves") <- forAll { (x : Int) in
			return forAllShrink(List<Int>.arbitrary, shrinker: List<Int>.shrink) { xs in
				return NonEmptyList(x, xs).tail == xs
			}
		}
		
		property("non-empty lists and lists that aren't empty are the same thing") <- forAll { (x : Int) in
			return forAllShrink(List<Int>.arbitrary, shrinker: List<Int>.shrink) { xs in
				return NonEmptyList(x, xs).toList() == List(x, xs)
			}
		}
		
		property("optional constructor behaves") <- forAllShrink(List<Int>.arbitrary, shrinker: List<Int>.shrink) { xs in
			switch xs.match {
			case .Nil:
				return NonEmptyList(xs) == nil
			case .Cons(let y, let ys):
				return NonEmptyList(xs)! == NonEmptyList(y, ys)
			}
		}
		
		property("NonEmptyList is a Semigroup") <- forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { l in
			return forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList<Int>.shrink) { r in
				return (l <> r).toList() == l.toList() <> r.toList()
			}
		}
		
		property("NonEmptyLists under double reversal is an identity") <- forAllShrink(NonEmptyList<Int>.arbitrary, shrinker: NonEmptyList.shrink) { l in
			return l.reverse().reverse() == l
		}
	}
}