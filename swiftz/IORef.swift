//
//  IORef.swift
//  swiftz
//
//  Created by Robert Widmann on 8/23/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation
import swiftz_core

// A mutable reference in the IO monad.  Mutations are not atomic.  Any
// serious threading should use MVars instead.
public struct IORef<A> {
  var value : STRef<RealWorld, A>
  
  // Reads the value from an IO ref and bundles it in the IO monad.
  public func readIORef() -> IO<A> {
    return stToIO(value.readSTRef())
  }
  
  // Writes a new value into the reference.
  public mutating func writeIORef(v: A) -> IO<()> {
    return stToIO(value.writeSTRef(v).fmap { (_) in
      return ()
    })
  }
  
  // Modifies the reference and returns the updated result.
  // Equivalent to 'writeIORef >> readIORef'
  public mutating func modifyIORef<B>(vfn : (A -> A)) -> IO<A> {
    return stToIO(value.modifySTRef(vfn)) >> self.readIORef()
  }
}

// Creates a new IORef
public func newIORef<A>(v: A) -> IO<IORef<A>> {
  return stRefToIO(STRef<RealWorld, A>(v)).bind({ (let vari) in
    return IO<IORef<A>>.pure(IORef(value: vari))
  })
}


private func stRefToIO<A>(m: STRef<RealWorld, A>) -> IO<STRef<RealWorld, A>> {
  return IO<STRef<RealWorld, A>>.pure(m)
}
