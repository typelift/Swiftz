//
//  FunctionSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 6/26/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

class FunctionSpec : XCTestCase {
    func testArrowLaws() {
        func assoc<A, B, C>(t : ((A, B), C)) -> (A, (B, C)) {
            return (t.0.0, (t.0.1, t.1))
        }
        
        property("identity") <- forAll { (x : Int8) in
            let a = Function<Int8, Int8>.arr(identity)
            return a.apply(x) == identity(x)
        }
        
        property("composition") <- forAll { (f : ArrowOf<Int8, Int8>, g : ArrowOf<Int8, Int8>) in
            return forAll { (x : Int8) in
                let la = Function.arr(f.getArrow) >>> Function.arr(g.getArrow)
                let ra = Function.arr(g.getArrow • f.getArrow)
                return la.apply(x) == ra.apply(x)
            }
        }
        
        property("first") <- forAll { (f : ArrowOf<Int8, Int8>) in
            let la = Function.arr(f.getArrow).first()
            let ra = Function.arr(Function.arr(f.getArrow).first().apply)
            return forAll { (x : Int8, y : Int8) in
                return la.apply(x, y) == ra.apply(x, y)
            }
        }
            
        property("first under composition") <- forAll { (f : ArrowOf<Int8, Int8>, g : ArrowOf<Int8, Int8>) in
            let la = Function.arr(f.getArrow) >>> Function.arr(g.getArrow)
            let ra = Function.arr(f.getArrow).first() >>> Function.arr(g.getArrow).first()
            return forAll { (x : Int8, y : Int8) in
                return la.first().apply(x, y) == ra.apply(x, y)
            }
        }
        
        property("first") <- forAll { (f : ArrowOf<Int8, Int8>) in
            let la = Function.arr(f.getArrow).first() >>> Function.arr(fst)
            let ra = Function<(Int8, Int8), Int8>.arr(fst) >>> Function.arr(f.getArrow)
            return forAll { (x : Int8, y : Int8) in
                return la.apply(x, y) == ra.apply(x, y)
            }
        }
        
        property("split") <- forAll { (f : ArrowOf<Int8, Int8>, g : ArrowOf<Int8, Int8>) in
            let la = Function.arr(f.getArrow).first() >>> (Function.arr(identity) *** Function.arr(g.getArrow))
            let ra = (Function.arr(identity) *** Function.arr(g.getArrow)) >>> Function.arr(f.getArrow).first()
            return forAll { (x : Int8, y : Int8) in
                return la.apply(x, y) == ra.apply(x, y)
            }
        }
        
//        property("") <- forAll { (f : ArrowOf<Int8, Int8>) in
//            let la = Function<((Int8, Int8), Int8), (Int8, (Int8, Int8))>.arr(f.getArrow).first().first() >>> Function.arr(assoc)
//            let im : Function<(Int8, Int8), (Int8, Int8)> = Function.arr(f.getArrow).first()
//            let ra = Function<((Int8, Int8), Int8), (Int8, (Int8, Int8))>.arr(assoc) >>> im
//            return forAll { (w : Int8, x : Int8, y : Int8, z : Int8) in
//                let l = la.apply((w, x), (y, z))
//                let r = ra.apply((w, x), (y, z))
//                return true
//            }
//        }
    }
    
    func testArrowChoiceLaws() {
        property("left") <- forAll { (f : ArrowOf<Int8, Int8>) in
            let la = Function.arr(f.getArrow).left()
            let ra = Function.arr(Function.arr(f.getArrow).left().apply)
            return forAll { (e : EitherOf<Int8, Int8>) in
                return la.apply(e.getEither) == ra.apply(e.getEither)
            }
        }
        
        property("composition") <- forAll { (f : ArrowOf<Int8, Int8>, g : ArrowOf<Int8, Int8>) in
            let la = Function.arr(g.getArrow • f.getArrow).left()
            let ra = Function.arr(f.getArrow).left() >>> Function.arr(g.getArrow).left()
            return forAll { (e : EitherOf<Int8, Int8>) in
                return la.apply(e.getEither) == ra.apply(e.getEither)
            }
        }
        
        property("left under composition") <- forAll { (f : ArrowOf<Int8, Int8>) in
            let la = Function.arr(f.getArrow) >>> Function.arr(Either<Int8, Int8>.Left)
            let ra = Function.arr(Either<Int8, Int8>.Left) >>> Function.arr(f.getArrow).left()
            return forAll { (x : Int8) in
                return la.apply(x) == ra.apply(x)
            }
        }
        
        property("choice") <- forAll { (f : ArrowOf<Int8, Int8>, g : ArrowOf<Int8, Int8>) in
            let la = Function.arr(f.getArrow).left() >>> (Function.arr(identity) +++ Function.arr(g.getArrow))
            let ra =  (Function.arr(identity) +++ Function.arr(g.getArrow)) >>> Function.arr(f.getArrow).left()
            return forAll { (e : EitherOf<Int8, Int8>) in
                return la.apply(e.getEither) == ra.apply(e.getEither)
            }
        }
        
        func assocSum(e : Either<Either<Int8, Int8>, Int8>) -> Either<Int8, Either<Int8, Int8>> {
            switch e {
            case let .Left(.Left(x)):
                return .Left(x)
            case let .Left(.Right(y)):
                return .Right(.Left(y))
            case let .Right(z):
                return .Right(.Right(z))
            }
        }
        
//        property("") <- forAll { (f : ArrowOf<Int8, Int8>, g : ArrowOf<Int8, Int8>) in
//            let la = Function.arr(f.getArrow).left().left() >>> Function.arr(assocSum)
//            let ra =  Function.arr(assocSum) >>> Function.arr(f.getArrow).left()
//            return forAll { (e : EitherOf<Int8, Int8>) in
//                return la.apply(e.getEither) == ra.apply(e.getEither)
//            }
//        }
    }
    
    func testArrowApplyLaws() {
        property("app") <- forAll { (x : Int8, y : Int8) in
            let app : Function<(Function<Int8, (Int8, Int8)>, Int8), (Int8, Int8)> = Function<Int8, (Int8, Int8)>.app()
            let la = Function<Int8, Function<Int8, (Int8, Int8)>>.arr({ x in Function.arr({ y in (x, y) }) }).first() >>> app
            return la.apply(x, y) == identity(x, y)
        }
        
        
    }
}
