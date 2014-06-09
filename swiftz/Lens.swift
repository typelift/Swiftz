//
//  Lens.swift
//  swiftz
//
//  Created by Maxwell Swadling on 8/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

class Lens<A, B> {
  typealias LensConst = (B -> Const<B, A>) -> A -> Const<B, A>
  typealias LensId = (B -> Id<B>) -> A -> Id<A>
  
  class func get(lens: LensConst, _ a: A) -> B {
    return (lens({ (b: B) -> Const<B, A> in return Const<B, A>(b) })(a)).runConst()
  }
  
  class func set(lens: LensId, _ b: B, _ a: A) -> A {
    return lens({ (_: B) -> Id<B> in return Id<B>(b) })(a).runId()
  }
  
  class func modify(lens: LensId, _ f: (B -> B), _ a: A) -> A {
    return lens({ (b: B) -> Id<B> in return Id<B>(f(b)) })(a).runId()
  }
}
