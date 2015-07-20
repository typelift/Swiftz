//
//  IdentitySpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 7/20/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

import Foundation
import XCTest
import Swiftz
import SwiftCheck

struct IdentityOf<A : Arbitrary> : Arbitrary, CustomStringConvertible {
	let getIdentity : Identity<A>
	
	init(_ id : Identity<A>) {
		self.getIdentity = id
	}
	
	init(_ x : A) {
		self.getIdentity = Identity(x)
	}
	
	var description : String {
		return "\(self.getIdentity)"
	}
	
	static var arbitrary : Gen<IdentityOf<A>> {
		return IdentityOf.init <^> A.arbitrary
	}
	
	static func shrink(bl : IdentityOf<A>) -> [IdentityOf<A>] {
		return A.shrink(bl.getIdentity.runIdentity).map(IdentityOf.init)
	}
}

class IdentitySpec : XCTestCase {
	func testProperties() {
		property("Identities of Equatable elements obey reflexivity") <- forAll { (l : IdentityOf<Int>) in
			return l.getIdentity == l.getIdentity
		}
		
		property("Identities of Equatable elements obey symmetry") <- forAll { (x : IdentityOf<Int>, y : IdentityOf<Int>) in
			return (x.getIdentity == y.getIdentity) == (y.getIdentity == x.getIdentity)
		}
		
		property("Identities of Equatable elements obey transitivity") <- forAll { (x : IdentityOf<Int>, y : IdentityOf<Int>, z : IdentityOf<Int>) in
			return (x.getIdentity == y.getIdentity) && (y.getIdentity == z.getIdentity) ==> (x.getIdentity == z.getIdentity)
		}
		
		property("Identities of Equatable elements obey negation") <- forAll { (x : IdentityOf<Int>, y : IdentityOf<Int>) in
			return (x.getIdentity != y.getIdentity) == !(x.getIdentity == y.getIdentity)
		}
		
		property("Identities of Comparable elements obey reflexivity") <- forAll { (l : IdentityOf<Int>) in
			return l.getIdentity == l.getIdentity
		}
		
		property("Identity obeys the Functor identity law") <- forAll { (x : IdentityOf<Int>) in
			return (x.getIdentity.fmap(identity)) == identity(x.getIdentity)
		}
		
		property("Identity obeys the Functor composition law") <- forAll { (f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>, x : IdentityOf<Int>) in
			return ((f.getArrow • g.getArrow) <^> x.getIdentity) == (x.getIdentity.fmap(g.getArrow).fmap(f.getArrow))
		}
		
		property("Identity obeys the Applicative identity law") <- forAll { (x : IdentityOf<Int>) in
			return (Identity.pure(identity) <*> x.getIdentity) == x.getIdentity
		}
		
		property("Identity obeys the first Applicative composition law") <- forAll { (fl : IdentityOf<ArrowOf<Int8, Int8>>, gl : IdentityOf<ArrowOf<Int8, Int8>>, x : IdentityOf<Int8>) in
			let f = fl.getIdentity.fmap({ $0.getArrow })
			let g = gl.getIdentity.fmap({ $0.getArrow })
			return (curry(•) <^> f <*> g <*> x.getIdentity) == (f <*> (g <*> x.getIdentity))
		}
		
		property("Identity obeys the second Applicative composition law") <- forAll { (fl : IdentityOf<ArrowOf<Int8, Int8>>, gl : IdentityOf<ArrowOf<Int8, Int8>>, x : IdentityOf<Int8>) in
			let f = fl.getIdentity.fmap({ $0.getArrow })
			let g = gl.getIdentity.fmap({ $0.getArrow })
			return (Identity.pure(curry(•)) <*> f <*> g <*> x.getIdentity) == (f <*> (g <*> x.getIdentity))
		}
		
		property("Identity obeys the Monad left identity law") <- forAll { (a : Int, fa : ArrowOf<Int, IdentityOf<Int>>) in
			let f = { $0.getIdentity } • fa.getArrow
			return (Identity.pure(a) >>- f) == f(a)
		}
		
		property("Identity obeys the Monad right identity law") <- forAll { (m : IdentityOf<Int>) in
			return (m.getIdentity >>- Identity.pure) == m.getIdentity
		}
		
		property("Identity obeys the Monad associativity law") <- forAll { (fa : ArrowOf<Int, IdentityOf<Int>>, ga : ArrowOf<Int, IdentityOf<Int>>, m : IdentityOf<Int>) in
			let f = { $0.getIdentity } • fa.getArrow
			let g = { $0.getIdentity } • ga.getArrow
			return ((m.getIdentity >>- f) >>- g) == (m.getIdentity >>- { x in f(x) >>- g })
		}
	}
}
