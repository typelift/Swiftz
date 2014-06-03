//
//  List.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// Desired implementation:
enum List<A> {
  case Nil()
  case Cons(A, List<A>)
}
