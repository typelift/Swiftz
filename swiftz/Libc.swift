//
//  Libc.swift
//  swiftz
//
//  Created by Maxwell Swadling on 10/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

// heh, overloading makes this cleaner than haskell...
func mallocPtr<A>(owner: AnyObject?) -> CMutablePointer<A> {
  return CMutablePointer(owner: owner, value: malloc(UInt(sizeof(A))).value)
}

func freePtr<A>(ptr: CMutablePointer<A>) {
  free(CMutableVoidPointer(owner: nil, value: ptr.value))
}
