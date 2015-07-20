//
//  MonadZip.swift
//  Swiftz
//
//  Created by Robert Widmann on 7/20/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

/// Monads that allow zipping.
public protocol MonadZip : Monad {
	/// An arbitrary domain.  Usually Any
	typealias C
	/// A monad with an arbitrary domain.
	typealias FC = K1<C>
	
	/// A Monad containing a zipped tuple.
	typealias FTAB = K1<(A, B)>
	
	/// Zip for monads.
	func mzip(_ : FB) -> FTAB
	
	/// ZipWith for monads.
	func mzipWith(_ : FB, _ : A -> B -> C) -> FC
	
	/// Unzip for monads.
	static func munzip(_ : FTAB) -> (Self, FB)
}
