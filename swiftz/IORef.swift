//
//  IORef.swift
//  swiftz
//
//  Created by Robert Widmann on 8/23/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public struct IORef<A> {
	var value : STRef<RealWorld, A>

	func readIORef() -> IO<A> {
		return stToIO(value.readSTRef())
	}

	mutating func writeIORef(v: A) -> IO<()> {
		return stToIO(value.writeSTRef(v).fmap { (_) in
			return ()
		})
	}

	mutating func atomicModifyIORef<B>(vfn : (A -> A)) -> IO<A> {
		return stToIO(value.modifySTRef(vfn)) >>= { (_) in
			return self.readIORef()
		}
	}
}

public func newIORef<A>(v: A) -> IO<IORef<A>> {
	return stRefToIO(STRef<RealWorld, A>(v)).bind({ (let vari) in
		return IO<IORef<A>>.pure(IORef(value: vari))
	})
}

private func stToIO<A>(m: ST<RealWorld, A>) -> IO<A> {
	return IO<A>.pure(m.runST())
}

private func stRefToIO<A>(m: STRef<RealWorld, A>) -> IO<STRef<RealWorld, A>> {
	return IO<STRef<RealWorld, A>>.pure(m)
}
