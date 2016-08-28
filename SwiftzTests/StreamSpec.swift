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

/// Generates a stream of arbitrary values.
extension Stream where Element : Arbitrary {
	public static var arbitrary : Gen<Stream<Element>> {
		return Element.arbitrary.flatMap { x in
			return Element.arbitrary.flatMap { y in
				return Element.arbitrary.flatMap { z in
					return Gen.pure(Stream.cycle([ x, y, z ]))
				}
			}
		}
	}
	
	public static func shrink(xs : Stream<Element>) -> [Stream<Element>] {
		return []
	}
}

extension Stream : WitnessedArbitrary {
	public typealias Param = Element
	
	public static func forAllWitnessed<A : Arbitrary>(wit : A -> Element, pf : (Stream<Element> -> Testable)) -> Property {
		return forAllShrink(Stream<A>.arbitrary, shrinker: Stream<A>.shrink, f: { bl in
			return pf(bl.fmap(wit))
		})
	}
}


class StreamSpec : XCTestCase {
	func testProperties() {
		property("pure behaves") <- forAll { (i : Int) in
			let xs = Stream.pure(i)
			return [UInt](1...10).all { n in
				return xs[n] == i
			}
		}
		
		property("Take behaves") <- forAll { (xs : Stream<Int>) in
			return [UInt](1...10).all { n in
				return xs.take(n).count == Int(n)
			}
		}
		
		property("Interleave behaves") <- forAll { (xs : Stream<Int>, ys : Stream<Int>) in
			return [UInt](1...10).all { n in
				let zs = xs.interleaveWith(ys)
				return zs[2 * n] == xs[n]
					&& zs[2 * n + 1] == ys[n]
			}
		}
		
		property("Stream obeys the Functor identity law") <- forAll { (x : Stream<Int>) in
			return forAll { (n : UInt) in
				return (x.fmap(identity)).take(n) == identity(x).take(n)				
			}
		}
		
		property("Stream obeys the Functor composition law") <- forAll { (f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>) in
			return forAll { (x : Stream<Int>) in
				return forAll { (n : UInt) in
					return ((f.getArrow • g.getArrow) <^> x).take(n) == (x.fmap(g.getArrow).fmap(f.getArrow)).take(n)
				}
			}
		}
		
		property("Stream obeys the Applicative identity law") <- forAll { (x : Stream<Int>) in
			return forAll { (n : UInt) in
				return (Stream.pure(identity) <*> x).take(n) == x.take(n)
			}
		}
		
		// Swift unroller can't handle our scale; Use only small lists.
		property("Stream obeys the first Applicative composition law") <- forAll { (fl : Stream<ArrowOf<Int8, Int8>>, gl : Stream<ArrowOf<Int8, Int8>>, x : Stream<Int8>) in
			return forAll { (n : UInt) in
				let f = fl.fmap({ $0.getArrow })
				let g = gl.fmap({ $0.getArrow })
				return (curry(•) <^> f <*> g <*> x).take(n) == (f <*> (g <*> x)).take(n)
			}
		}
		
		property("Stream obeys the second Applicative composition law") <- forAll { (fl : Stream<ArrowOf<Int8, Int8>>, gl : Stream<ArrowOf<Int8, Int8>>, x : Stream<Int8>) in
			return forAll { (n : UInt) in
				let f = fl.fmap({ $0.getArrow })
				let g = gl.fmap({ $0.getArrow })
				return (Stream.pure(curry(•)) <*> f <*> g <*> x).take(n) == (f <*> (g <*> x)).take(n)
			}
		}
		
		/// These three take *forever* to execute.  It's scary how much stack 
		/// space it takes to force these streams.
		
		property("Stream obeys the Monad left identity law") <- forAll { (a : Int, fa : ArrowOf<Int, Int>) in
			let f : Int -> Stream<Int> = Stream<Int>.pure • fa.getArrow
			return forAll { (n : UInt) in
				return (Stream<Int>.pure(a) >>- f).take(n) == f(a).take(n)
			}
		}.once
		
		property("Stream obeys the Monad right identity law") <- forAll { (m : Stream<Int>) in
			return forAll { (n : UInt) in
				return (m >>- Stream<Int>.pure).take(n) == m.take(n)
			}
		}.once
		
		property("Stream obeys the Monad associativity law") <- forAll { (fa : ArrowOf<Int, Int>, ga : ArrowOf<Int, Int>) in
			
			let f : Int -> Stream<Int> = Stream<Int>.pure • fa.getArrow
			let g : Int -> Stream<Int> = Stream<Int>.pure • ga.getArrow
			return forAll { (m : Stream<Int>) in
				return forAll { (n : UInt) in
					return ((m >>- f) >>- g).take(n) == (m >>- { x in f(x) >>- g }).take(n)
				}
			}
		}.once
		
		property("Stream obeys the Comonad identity law") <- forAll { (x : Stream<Int>) in
			return forAll { (n : UInt) in
				return x.extend({ $0.extract() }).take(n) == x.take(n)
			}
		}
		
		property("Stream obeys the Comonad composition law") <- forAll { (ff : ArrowOf<Int, Int>) in
			return forAll { (x : Identity<Int>) in
				return forAll { (n : UInt) in
					let f : Identity<Int> -> Int = ff.getArrow • { $0.runIdentity }
					return x.extend(f).extract() == f(x)
				}
			}
		}
		
		property("Stream obeys the Comonad composition law") <- forAll { (ff : ArrowOf<Int, Int>, gg : ArrowOf<Int, Int>) in
			return forAll { (x : Stream<Int>) in
				let f : Stream<Int> -> Int = ff.getArrow • { $0.head }
				let g : Stream<Int> -> Int = gg.getArrow • { $0.head }
				return forAll { (n : UInt) in
					return x.extend(f).extend(g).take(n) == x.extend({ g($0.extend(f)) }).take(n)
				}
			}
		}

        property("sequence occurs in order") <- forAll { (xs : [String]) in
            let seq = sequence(xs.map({ x in Stream.pure(x).take(1) }))
            return forAllNoShrink(Gen.pure(seq)) { ss in
                return ss.first ?? [] == xs
            }
        }
    }
}
