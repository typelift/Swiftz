//
//  StreamSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 4/10/16.
//  Copyright © 2016 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

/*
/// Generates a Swiftz.Stream of arbitrary values.
extension Swiftz.Stream where Element : Arbitrary {
	public static var arbitrary : Gen<Swiftz.Stream<Element>> {
		return Element.arbitrary.flatMap { x in
			return Element.arbitrary.flatMap { y in
				return Element.arbitrary.flatMap { z in
					return Gen.pure(Swiftz.Stream.cycle([ x, y, z ]))
				}
			}
		}
	}
	
	public static func shrink(_ xs : Swiftz.Stream) -> [Swiftz.Stream] {
		return []
	}
}

extension Swiftz.Stream : WitnessedArbitrary {
	public typealias Param = Element
	
	public static func forAllWitnessed<A : Arbitrary>(_ wit : (A) -> Element, pf : ((Swiftz.Stream) -> Testable)) -> Property {
		return forAllShrink(Swiftz.Stream<A>.arbitrary, shrinker: Swiftz.Stream<A>.shrink, f: { bl in
			return pf(bl.fmap(wit))
		})
	}
}


class StreamSpec : XCTestCase {
	func testProperties() {
		
		property("pure behaves") <- forAll { (i : Int) in
			let xs = Swiftz.Stream.pure(i)
			return [UInt](1...10).all { n in
				return xs[n] == i
			}
		}
		
		property("Take behaves") <- forAll { (xs : Swiftz.Stream) in
			return [UInt](1...10).all { n in
				return xs.take(n).count == Int(n)
			}
		}
		
		property("Interleave behaves") <- forAll { (xs : Swiftz.Stream, ys : Swiftz.Stream) in
			return [UInt](1...10).all { n in
				let zs = xs.interleaveWith(ys)
				return zs[2 * n] == xs[n]
					&& zs[2 * n + 1] == ys[n]
			}
		}
		
		property("Swiftz.Stream obeys the Functor identity law") <- forAll { (x : Swiftz.Stream) in
			return forAll { (n : UInt) in
				return (x.fmap(identity)).take(n) == identity(x).take(n)				
			}
		}
		
		property("Swiftz.Stream obeys the Functor composition law") <- forAll { (_ f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>) in
			return forAll { (x : Swiftz.Stream<Int>) in
				return forAll { (n : UInt) in
					return ((f.getArrow • g.getArrow) <^> x).take(n) == (x.fmap(g.getArrow).fmap(f.getArrow)).take(n)
				}
			}
		}
		
		property("Swiftz.Stream obeys the Applicative identity law") <- forAll { (x : Swiftz.Stream) in
			return forAll { (n : UInt) in
				return (Swiftz.Stream.pure(identity) <*> x).take(n) == x.take(n)
			}
		}
		
		// Swift unroller can't handle our scale; Use only small lists.
		property("Swiftz.Stream obeys the first Applicative composition law") <- forAll { (fl : Swiftz.Stream, gl : Swiftz.Stream, x : Swiftz.Stream) in
			return forAll { (n : UInt) in
				let f = fl.fmap({ $0.getArrow })
				let g = gl.fmap({ $0.getArrow })
				return (curry(•) <^> f <*> g <*> x).take(n) == (f <*> (g <*> x)).take(n)
			}
		}
		
		property("Swiftz.Stream obeys the second Applicative composition law") <- forAll { (fl : Swiftz.Stream, gl : Swiftz.Stream, x : Swiftz.Stream) in
			return forAll { (n : UInt) in
				let f = fl.fmap({ $0.getArrow })
				let g = gl.fmap({ $0.getArrow })
				return (Swiftz.Stream.pure(curry(•)) <*> f <*> g <*> x).take(n) == (f <*> (g <*> x)).take(n)
			}
		}
		
		/// These three take *forever* to execute.  It's scary how much stack 
		/// space it takes to force these Swiftz.Streams.
		
		property("Swiftz.Stream obeys the Monad left identity law") <- forAll { (a : Int, fa : ArrowOf<Int, Int>) in
			let f : (Int) -> Swiftz.Stream<Int> = Swiftz.Stream<Int>.pure • fa.getArrow
			return forAll { (n : UInt) in
				return (Swiftz.Stream<Int>.pure(a) >>- f).take(n) == f(a).take(n)
			}
		}.once
		
		property("Swiftz.Stream obeys the Monad right identity law") <- forAll { (m : Swiftz.Stream) in
			return forAll { (n : UInt) in
				return (m >>- Swiftz.Stream<Int>.pure).take(n) == m.take(n)
			}
		}.once
		
		property("Swiftz.Stream obeys the Monad associativity law") <- forAll { (fa : ArrowOf<Int, Int>, ga : ArrowOf<Int, Int>) in
			
			let f : (Int) -> Swiftz.Stream<Int> = Swiftz.Stream<Int>.pure • fa.getArrow
			let g : (Int) -> Swiftz.Stream<Int> = Swiftz.Stream<Int>.pure • ga.getArrow
			return forAll { (m : Swiftz.Stream<Int>) in
				return forAll { (n : UInt) in
					return ((m >>- f) >>- g).take(n) == (m >>- { x in f(x) >>- g }).take(n)
				}
			}
		}.once
		
		property("Swiftz.Stream obeys the Comonad identity law") <- forAll { (x : Swiftz.Stream) in
			return forAll { (n : UInt) in
				return x.extend({ $0.extract() }).take(n) == x.take(n)
			}
		}
		
		property("Swiftz.Stream obeys the Comonad composition law") <- forAll { (ff : ArrowOf<Int, Int>) in
			return forAll { (x : Identity<Int>) in
				return forAll { (n : UInt) in
					let f : (Identity<Int>) -> Int = ff.getArrow • { $0.runIdentity }
					return x.extend(f).extract() == f(x)
				}
			}
		}
		
		property("Swiftz.Stream obeys the Comonad composition law") <- forAll { (ff : ArrowOf<Int, Int>, gg : ArrowOf<Int, Int>) in
			return forAll { (x : Swiftz.Stream<Int>) in
				let f : (Swiftz.Stream<Int>) -> Int = ff.getArrow • { $0.head }
				let g : (Swiftz.Stream<Int>) -> Int = gg.getArrow • { $0.head }
				return forAll { (n : UInt) in
					return x.extend(f).extend(g).take(n) == x.extend({ g($0.extend(f)) }).take(n)
				}
			}
		}

        property("sequence occurs in order") <- forAll { (xs : [String]) in
            let seq = sequence(xs.map({ x in Swiftz.Stream.pure(x).take(1) }))
            return forAllNoShrink(Gen.pure(seq)) { ss in
                return ss.first ?? [] == xs
            }
        }
    }
}
*/
